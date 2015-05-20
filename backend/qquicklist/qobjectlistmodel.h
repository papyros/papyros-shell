#ifndef QOBJECTLISTMODEL_H
#define QOBJECTLISTMODEL_H

#include <QAbstractListModel>
#include <QtQml>
#include <QSet>
#include <QBasicTimer>
#include <functional>

class QObjectListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_DISABLE_COPY(QObjectListModel)

    //! Whether changes to underlying objects are exposed via `dataChanged` signals
    Q_PROPERTY(bool elementChangeTracking READ elementChangeTracking WRITE setElementChangeTracking NOTIFY elementChangeTrackingChanged)

public:
    //! default constructor
    QObjectListModel(QObject * parent = NULL);

    //! A model that creates instances via a given metaobject
    QObjectListModel(const QMetaObject * mo, QObject * parent = NULL);
    //! A model that creates instances using a factory function
    QObjectListModel(const std::function<QObject*()> & factory, QObject * parent = NULL);

    //! A factory to get a model of QList<T*>
    template<class T> static QObjectListModel * create(QList<T*> list, QObject * parent = NULL) {
        QObjectListModel * newModel = new QObjectListModel(&T::staticMetaObject, parent);

        newModel->clear();
        newModel->insert(list);

        return newModel;
    }

    ~QObjectListModel();

    bool elementChangeTracking() const;
    void setElementChangeTracking(bool tracking);
    Q_SIGNAL void elementChangeTrackingChanged(bool);
    int rowCount(const QModelIndex &) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
    bool setData(const QModelIndex &index, const QVariant &value, int role) Q_DECL_OVERRIDE;
    bool insert(QObject * const &item, int row = -1);
    template<class T> bool insert(QList <T*> const &items, int row = -1) {
        if(row == -1)
            row = m_data.count();

        if(!items.empty()) {
            beginInsertRows(QModelIndex(), row, row + items.count() - 1);
            for(int i = 0; i < items.count(); i++) {
                Q_ASSERT(items[i]);
                m_data.insert(i + row,items[i]);
                updateTracking(items[i]);
                QQmlEngine::setObjectOwnership(items[i], QQmlEngine::CppOwnership);
            }
            endInsertRows();
        }

        return true;
    }
    bool moveRows(int sourceRow, int count, int destinationChild);
    bool moveRows(const QModelIndex & sourceParent, int sourceRow, int count, const QModelIndex & destinationParent, int destinationChild) Q_DECL_OVERRIDE;
    bool clear();
    bool removeAll(QObject * const &item);
    bool removeOne(QObject * const &item);
    bool removeAt(int row);
    bool removeFirst();
    bool removeLast();
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) Q_DECL_OVERRIDE;
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) Q_DECL_OVERRIDE;

    template <typename T, typename LessThan>
    void sort(T *t, LessThan lessThan) {
        Q_UNUSED(t);

        QList<T*> listtosort;

        foreach(QObject * object, m_data) {
            listtosort << dynamic_cast<T*>(object);
        }

        qSort(listtosort.begin(),listtosort.end(),lessThan);

        int oldpos = 0;

        for(int i = 0; i < listtosort.length(); i++) {
            oldpos = m_data.lastIndexOf((QObject*)listtosort[i]);
            if(oldpos > i) {
                beginMoveRows(QModelIndex(),oldpos,oldpos,QModelIndex(),i);
                m_data.move(oldpos,i);
                endMoveRows();
            }
        }
    }

    Q_INVOKABLE QVariant get(int index) const;

protected:
    //! Emits the notifications of changes done on the underlying QObject properties
    void timerEvent(QTimerEvent * ev);

private:
    //! Updates the property tracking connections on given object.
    void updateTracking(QObject* obj);
    //! Receives property notification changes
    Q_SLOT void propertyNotification();

    QObjectList m_data;
    std::function<QObject*()> m_factory;
    bool m_tracking;
    QBasicTimer m_notifyTimer;
    QMap<int, char> m_notifyIndexes;
};

#endif // QOBJECTMODEL_H