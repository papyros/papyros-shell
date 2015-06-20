#ifndef QQUICKLIST_H
#define QQUICKLIST_H

#include <QAbstractListModel>
#include <QtQml>
#include <functional>
#include "qobjectlistmodel.h"

class QObjectListModel;

template<typename T> class QQuickList : public QList<T*> {

    QObjectListModel * m_model;

public:

    typedef typename QList<T*>::iterator iterator;

    inline QQuickList() : m_model(new QObjectListModel(&T::staticMetaObject)) {

    }

    explicit inline QQuickList(const QList<T*> &list) :
        QList<T*>(list),
        m_model(QObjectListModel::create(list))
    {
    }

    inline ~QQuickList() {
        delete m_model;
    }

    inline QObjectListModel * getModel() { return m_model; }

    inline QQuickList<T> &operator=(const QList<T*> &l) {
        this->clear();
        this->append(l);
        return *this;
    }
    inline QQuickList<T> &operator=(const QQuickList<T> &l) {
        this->clear();
        this->append(l);
        return *this;
    }
#ifdef Q_COMPILER_RVALUE_REFS
    inline QQuickList(QList<T*> &&other) : QList<T*>(other), m_model(QObjectListModel::create(other))
    {
        T * assertObject = new T();
        Q_ASSERT_X(qobject_cast<QObject *>(assertObject),"QQuickList<T>::QQuickList","Typename T does not inherit from QObject.");
        delete assertObject;
    }
    inline QQuickList &operator=(QList<T*> &&other) {
        this->clear();
        this->append(*other);
        return *this;
    }
    inline QQuickList &operator=(QQuickList<T> &&other) {
        this->clear();
        this->append(*other);
        return *this;
    }
#endif

#ifdef Q_COMPILER_INITIALIZER_LISTS
    inline QQuickList(std::initializer_list<T> args)
        : QList<T*>(args)
    { }
#endif

    inline void clear() {
        m_model->clear();
        QList<T*>::clear();
    }

    inline void append(T *const & t) { QList<T*>::append(t); m_model->insert(t); }
    inline void append(const QList<T*> &t) { QList<T*>::append(t); m_model->insert(t); }
    inline void prepend(T *const &t) { QList<T*>::prepend(t); m_model->insert(t,0); }
    inline void insert(int i, T *const &t) { QList<T*>::insert(i,t); m_model->insert(t,i); }
    inline void replace(int i, T *const &t) { QList<T*>::replace(i,t); m_model->insert(t,i); m_model->removeAt(i + 1); }
    inline void removeAt(int i) { QList<T*>::removeAt(i); m_model->removeAt(i); }
    inline int removeAll(T *const &t) { m_model->removeAll(t); return QList<T*>::removeAll(t); }
    inline bool removeOne(T *const &t) { m_model->removeOne(t); return QList<T*>::removeOne(t); }
    inline T * takeAt(int i) { m_model->removeAt(i); return QList<T*>::takeAt(i); }
    inline T * takeFirst() { m_model->removeAt(0); return QList<T*>::takeFirst(); }
    inline T * takeLast() { m_model->removeAt(QList<T*>::count() - 1); return QList<T*>::takeLast(); }
    inline void move(int from, int to) { QList<T*>::move(from,to); m_model->moveRows(from,1,to); }
    inline void swap(int i, int j) {
        if(j>i) {
            m_model->moveRows(i,1,j-1);
            m_model->moveRows(j,1,i);
        }
        else if (i>j) {
            m_model->moveRows(j,1,i-1);
            m_model->moveRows(i,1,j);
        }
        else
            return;

        QList<T*>::swap(i,j);
    }

    iterator insert(iterator before, T *const &t);
    iterator erase(iterator pos);
    iterator erase(iterator first, iterator last);

    inline void removeFirst() { QList<T*>::removeFirst(); m_model->removeFirst(); }
    inline void removeLast() { QList<T*>::removeLast(); m_model->removeLast(); }

    // stl compatibility
    inline void push_back(T *const &t) { append(t); }
    inline void push_front(T *const &t) { prepend(t); }
    inline void pop_front() { removeFirst(); }
    inline void pop_back() { removeLast(); }

    // comfort
    inline QQuickList<T> &operator+=(const QList<T*> &l)
    { m_model->insert(l); QList<T*>::operator+=(l); return *this; }
    inline QQuickList<T> &operator+=(const QQuickList<T> &l)
    { return operator+=(QList<T*>(l)); }
    inline QQuickList<T> &operator+(const QList<T*> &l) const // You should not add elements like this (for fluidity purpose)
    { QQuickList<T> * n = new QQuickList<T>(); n->append(*this); n->append(l); return *n; }
//    inline QQuickList<T> operator+(const QQuickList<T> &l)
//    { return QQuickList::operator+(QList<T*>(l)); }
    inline QQuickList<T> &operator+=(T *const &t)
    { append(t); return *this; }
    inline QQuickList<T> &operator<< (T *const &t)
    { append(t); return *this; }
    inline QQuickList<T> &operator<<(const QList<T*> &l)
    { *this += l; return *this; }
    inline QQuickList<T> &operator<<(const QQuickList<T> &l)
    { return operator<<(l); }

    inline operator QList<T*> ()
    { return (QList<T*>)*this; }

    template <typename LessThan>
    inline void sort(LessThan lessThan)
    {
        if (this->begin() != this->end()){
            qSort(this->begin(),this->end(), lessThan);
            m_model->sort((*this->begin()),lessThan);
        }
    }
};

template<typename T>
inline typename QQuickList<T>::iterator QQuickList<T>::insert(iterator before, T *const &t)
{
    m_model->insert(t,before-QList<T*>::begin());
    return QList<T*>::insert(before,t);
}

template<typename T>
inline typename QQuickList<T>::iterator QQuickList<T>::erase(iterator pos)
{
    m_model->removeAt(pos - QList<T*>::begin());
    return QList<T*>::erase(pos);
}

template<typename T>
inline typename QQuickList<T>::iterator QQuickList<T>::erase(iterator first, iterator last)
{
    m_model->removeRows(first - QList<T*>::begin(),last - first);
    return QList<T*>::erase(first,last);
}

#endif // QQUICKLIST_H