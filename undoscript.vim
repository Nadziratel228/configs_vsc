//AVL-tree
// Create Node
struct Node {
  int key;
  struct Node *left;
  struct Node *right;
  int height;
};

int max(int a, int b);

// Calculate height
int height(struct Node *N) {
  if (N == NULL)
    return 0;
  return N->height;
}

int max(int a, int b) {
  return (a > b) ? a : b;
}

// Create a node
struct Node *newNode(int key) {
  struct Node *node = (struct Node *)
    malloc(sizeof(struct Node));
  node->key = key;
  node->left = NULL;
  node->right = NULL;
  node->height = 1;
  return (node);
}

// Right rotate
struct Node *rightRotate(struct Node *y) {
  struct Node *x = y->left;
  struct Node *T2 = x->right;

  x->right = y;
  y->left = T2;

  y->height = max(height(y->left), height(y->right)) + 1;
  x->height = max(height(x->left), height(x->right)) + 1;

  return x;
}

// Left rotate
struct Node *leftRotate(struct Node *x) {
  struct Node *y = x->right;
  struct Node *T2 = y->left;

  y->left = x;
  x->right = T2;

  x->height = max(height(x->left), height(x->right)) + 1;
  y->height = max(height(y->left), height(y->right)) + 1;

  return y;
}

// Get the balance factor
int getBalance(struct Node *N) {
  if (N == NULL)
    return 0;
  return height(N->left) - height(N->right);
}

// Insert node
struct Node *insertNode(struct Node *node, int key) {
  // Find the correct position to insertNode the node and insertNode it
  if (node == NULL)
    return (newNode(key));

  if (key < node->key)
    node->left = insertNode(node->left, key);
  else if (key > node->key)
    node->right = insertNode(node->right, key);
  else
    return node;

  // Update the balance factor of each node and
  // Balance the tree
  node->height = 1 + max(height(node->left),
               height(node->right));

  int balance = getBalance(node);
  if (balance > 1 && key < node->left->key)
    return rightRotate(node);

  if (balance < -1 && key > node->right->key)
    return leftRotate(node);

  if (balance > 1 && key > node->left->key) {
    node->left = leftRotate(node->left);
    return rightRotate(node);
  }

  if (balance < -1 && key < node->right->key) {
    node->right = rightRotate(node->right);
    return leftRotate(node);
  }

  return node;
}

struct Node *minValueNode(struct Node *node) {
  struct Node *current = node;

  while (current->left != NULL)
    current = current->left;

  return current;
}

// Delete a nodes
struct Node *deleteNode(struct Node *root, int key) {
  // Find the node and delete it
  if (root == NULL)
    return root;

  if (key < root->key)
    root->left = deleteNode(root->left, key);

  else if (key > root->key)
    root->right = deleteNode(root->right, key);

  else {
    if ((root->left == NULL) || (root->right == NULL)) {
      struct Node *temp = root->left ? root->left : root->right;

      if (temp == NULL) {
        temp = root;
        root = NULL;
      } else
        *root = *temp;
      free(temp);
    } else {
      struct Node *temp = minValueNode(root->right);

      root->key = temp->key;

      root->right = deleteNode(root->right, temp->key);
    }
  }

  if (root == NULL)
    return root;

  // Update the balance factor of each node and
  // balance the tree
  root->height = 1 + max(height(root->left),
               height(root->right));

  int balance = getBalance(root);
  if (balance > 1 && getBalance(root->left) >= 0)
    return rightRotate(root);

  if (balance > 1 && getBalance(root->left) < 0) {
    root->left = leftRotate(root->left);
    return rightRotate(root);
  }

  if (balance < -1 && getBalance(root->right) <= 0)
    return leftRotate(root);

  if (balance < -1 && getBalance(root->right) > 0) {
    root->right = rightRotate(root->right);
    return leftRotate(root);
  }

  return root;
}

// Print the tree
void printPreOrder(struct Node *root) {
  if (root != NULL) {
    printf("%d ", root->key);
    printPreOrder(root->left);
    printPreOrder(root->right);
  }
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



//Splay-tree
// An AVL tree node

struct node {

    int key;

    struct node *left, *right;

};

 

/* Helper function that allocates a new node with the given key and

 NULL left and right pointers. */

struct node* newNode(int key) {

    struct node* node = (struct node*) malloc(sizeof(struct node));

    node->key = key;

    node->left = node->right = NULL;

    return (node);

}

 

// A utility function to right rotate subtree rooted with y

// See the diagram given above.

struct node *rightRotate(struct node *x) {

    struct node *y = x->left;

    x->left = y->right;

    y->right = x;

    return y;

}

 

// A utility function to left rotate subtree rooted with x

// See the diagram given above.

struct node *leftRotate(struct node *x) {

    struct node *y = x->right;

    x->right = y->left;

    y->left = x;

    return y;

}

 

// This function brings the key at root if key is present in tree.

// If key is not present, then it brings the last accessed item at

// root.  This function modifies the tree and returns the new root

struct node *splay(struct node *root, int key) {

    // Base cases: root is NULL or key is present at root

    if (root == NULL || root->key == key)

        return root;

 

    // Key lies in left subtree

    if (root->key > key) {

        // Key is not in tree, we are done

        if (root->left == NULL)

            return root;

 

        // Zig-Zig (Left Left)

        if (root->left->key > key) {

            // First recursively bring the key as root of left-left

            root->left->left = splay(root->left->left, key);

 

            // Do first rotation for root, second rotation is done after else

            root = rightRotate(root);

        } else if (root->left->key < key) // Zig-Zag (Left Right)

        {

            // First recursively bring the key as root of left-right

            root->left->right = splay(root->left->right, key);

 

            // Do first rotation for root->left

            if (root->left->right != NULL)

                root->left = leftRotate(root->left);

        }

 

        // Do second rotation for root

        return (root->left == NULL) ? root : rightRotate(root);

    } else // Key lies in right subtree

    {

        // Key is not in tree, we are done

        if (root->right == NULL)

            return root;

 

        // Zag-Zig (Right Left)

        if (root->right->key > key) {

            // Bring the key as root of right-left

            root->right->left = splay(root->right->left, key);

 

            // Do first rotation for root->right

            if (root->right->left != NULL)

                root->right = rightRotate(root->right);

        } else if (root->right->key < key)// Zag-Zag (Right Right)

        {

            // Bring the key as root of right-right and do first rotation

            root->right->right = splay(root->right->right, key);

            root = leftRotate(root);

        }

 

        // Do second rotation for root

        return (root->right == NULL) ? root : leftRotate(root);

    }

}

 

// The search function for Splay tree.  Note that this function

// returns the new root of Splay Tree.  If key is present in tree

// then, it is moved to root.

struct node *search(struct node *root, int key) {

    return splay(root, key);

}

 

// A utility function to print preorder traversal of the tree.

// The function also prints height of every node

void preOrder(struct node *root) {

    if (root != NULL) {

        printf("%d ", root->key);

        preOrder(root->left);

        preOrder(root->right);

    }

}



||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



neerc.ifmo.ru
Красно-черное дерево — Викиконспекты
21–30 minutes

Красно-чёрное дерево (англ. red-black tree) — двоичное дерево поиска, в котором баланс осуществляется на основе "цвета" узла дерева, который принимает только два значения: "красный" (англ. red) и "чёрный" (англ. black).

Пример красно-чёрного дерева.

При этом все листья дерева являются фиктивными и не содержат данных, но относятся к дереву и являются чёрными.

Для экономии памяти фиктивные листья можно сделать одним общим фиктивным листом.

    1 Свойства
        1.1 Оригинальные
        1.2 Альтернативные
    2 Высота красно-черного дерева
    3 Операции
        3.1 Вставка элемента
        3.2 Удаление вершины
        3.3 Объединение красно-чёрных деревьев
        3.4 Разрезание красно-чёрного дерева
    4 Преимущества красно-чёрных деревьев
    5 Связь с 2-3 и 2-4 деревьями
        5.1 Изоморфизм деревьев
        5.2 Корректность сопоставления деревьев
        5.3 Сопоставление операций в деревьях
    6 См. также
    7 Примечания
    8 Источники информации

Свойства
Оригинальные

Красно-чёрным называется бинарное поисковое дерево, у которого каждому узлу сопоставлен дополнительный атрибут — цвет и для которого выполняются следующие свойства:

    Каждый узел промаркирован красным или чёрным цветом
    Корень и конечные узлы (листья) дерева — чёрные
    У красного узла родительский узел — чёрный
    Все простые пути из любого узла x до листьев содержат одинаковое количество чёрных узлов
    Чёрный узел может иметь чёрного родителя

Ослабленное красно-чёрное дерево.

Определим ослабленное красно-чёрное дерево как красно-чёрное дерево, корень которого может быть как чёрным, так и красным. Докажем, что при таком условии не будут выполняться и некоторые другие свойства красно-черных деревьев. При добавлении вершины около корня могут возникнуть повороты, и корневая вершина перейдет в какое-то поддерево. Из-за этого может возникнуть ситуация, в которой подряд будут идти две красные вершины. То же самое может произойти из-за перекрашиваний возле корня. Если мы продолжим вставлять элементы подобным образом, свойства дерева перестанут выполняться, и оно перестанет быть сбалансированным. Таким образом, время выполнения некоторых операций ухудшится.

Перед тем, как перейдем к примеру, договоримся, что мы разрешим в ослабленном красно-чёрном дереве при первом добавлении вершин (обеих, правой и левой) к красному корню делать их черными (немного модифицированный алгоритм вставки). Предыдущее условие можно заменить на другое, позволяющее корню иметь красных детей.

Рассмотрим пример справа. Получим такое дерево добавляя ключи в следующем порядке: 10, 6, 45, 4, 8. На примере можно видеть, что после добавления вершины с ключом 0 и соответствующих перекрашиваний вершина с ключом 6 становится красной с красным родителем. Дальше добавим 5. Так как мы добавляем к черной вершине, все свойства дерева сохраняются без перекрашиваний. Но добавим после этого (−3). Тогда вершина с ключом 4 станет красной (0 и 5 — черными) и у нас образуются три красные вершины подряд. Продолжая добавлять вершины таким образом, мы можем сделать сильно разбалансированное дерево.
Альтернативные

В книге Кормена "Алгоритмы: построение и анализ" дается немного иное определение красно-черного дерева, а именно:

Двоичное дерево поиска является красно-чёрным, если обладает следующими свойствами:

    Каждая вершина — либо красная, либо черная
    Каждый лист — черный
    Если вершина красная, оба ее ребенка черные
    Все пути, идущие от корня к листьям, содержат одинаковое количество черных вершин

То, что только черная вершина может иметь красных детей, совместно с 4-ым свойством говорит о том, что корень дерева должен быть черным, а значит определения можно считать эквивалентными.
Высота красно-черного дерева
Определение:
Будем называть чёрной высотой (англ. black-height) вершины x число чёрных вершин на пути из x в лист.
Лемма:

В красно-черном дереве с черной высотой hb количество внутренних вершин не менее 2hb−1−1.
Доказательство:
▹

Докажем по индукции по обычной высоте h(x), что поддерево любого узла x с черной высотой hb(x) содержит не менее 2hb(x)−1−1 внутренних узлов. Здесь h(x) — кратчайшее расстояние от вершины x до какого-то из листьев.

База индукции:

Если высота узла x равна 1, то x — это лист, hb(x)=1, 21−1−1=0.

Переход:

Так как любая внутренняя вершина (вершина, у которой высота положительна) имеет двух потомков, то применим предположение индукции к ним — их высоты на единицу меньше высоты x. Тогда черные высоты детей могут быть hb(x) или hb(x)−1 — если потомок красный или черный соответственно.

Тогда по предположению индукции в каждом из поддеревьев не менее 2hb(x)−2−1 вершин. Тогда всего в поддереве не менее 2⋅(2hb(x)−2−1)+1=2hb(x)−1−1 вершин (+1 — мы учли еще саму вершину x).

Переход доказан. Теперь, если мы рассмотрим корень всего дерева в качестве x, то получится, что всего вершин в дереве не менее 2hb−1−1.
Следовательно, утверждение верно и для всего дерева.
◃
Теорема:

Красно-чёрное дерево с N ключами имеет высоту h=O(log⁡N).
Доказательство:
▹

Рассмотрим красно-чёрное дерево с высотой h. Так как у красной вершины чёрные дети (по свойству 3) количество красных вершин не больше h2. Тогда чёрных вершин не меньше, чем h2−1.

По доказанной лемме, для количества внутренних вершин в дереве N выполняется неравенство:

N⩾2h/2−1

Прологарифмировав неравенство, имеем:

log⁡(N+1)⩾h2

2log⁡(N+1)⩾h
h⩽2log⁡(N+1)
◃
Операции

Узел, с которым мы работаем, на картинках имеет имя x.
Вставка элемента

Каждый элемент вставляется вместо листа, поэтому для выбора места вставки идём от корня до тех пор, пока указатель на следующего сына не станет nil (то есть этот сын — лист). Вставляем вместо него новый элемент с нулевыми потомками и красным цветом. Теперь проверяем балансировку. Если отец нового элемента черный, то никакое из свойств дерева не нарушено. Если же он красный, то нарушается свойство 3, для исправления достаточно рассмотреть два случая:

    "Дядя" этого узла тоже красный. Тогда, чтобы сохранить свойства 3 и 4, просто перекрашиваем "отца" и "дядю" в чёрный цвет, а "деда" — в красный. В таком случае черная высота в этом поддереве одинакова для всех листьев и у всех красных вершин "отцы" черные. Проверяем, не нарушена ли балансировка. Если в результате этих перекрашиваний мы дойдём до корня, то в нём в любом случае ставим чёрный цвет, чтобы дерево удовлетворяло свойству 2. Untitled-1.png
    "Дядя" чёрный. Если выполнить только перекрашивание, то может нарушиться постоянство чёрной высоты дерева по всем ветвям. Поэтому выполняем поворот. Если добавляемый узел был правым потомком, то необходимо сначала выполнить левое вращение, которое сделает его левым потомком. Таким образом, свойство 3 и постоянство черной высоты сохраняются.

Untitled-2.png

Псевдокод:

func insert(key)
    Node t = Node(key, red, nil, nil) // конструктор, в который передаем ключ, цвет, левого и правого ребенка 
    if дерево пустое
        root = t
        t.parent = nil
    else
        Node p = root
        Node q = nil
        while p != nil // спускаемся вниз, пока не дойдем до подходящего листа 
            q = p
            if p.key < t.key
                p = p.right
            else
                p = p.left
        t.parent = q
        // добавляем новый элемент красного цвета 
        if q.key < t.key
            q.right = t
        else
            q.left = t
     fixInsertion(t) // проверяем, не нарушены ли свойства красно-черного дерева 

func fixInsertion(t: Node)
    if t — корень
        t = black
        return
    // далее все предки упоминаются относительно t 
    while "отец" красный // нарушается свойство 3 
        if "отец" — левый ребенок
            if есть красный "дядя"
                 parent = black
                 uncle = black
                 grandfather = red
                 t = grandfather 
            else
                if t — правый сын
                    t = parent
                    leftRotate(t)
                parent = black
                grandfather = red
                rightRotate(grandfather)
        else // "отец" — правый ребенок 
            if есть красный "дядя"
                parent = black
                uncle = black
                grandfather = red
                t = grandfather
            else // нет "дяди" 
                if t — левый ребенок
                    t = t.parent
                    rightRotate(t)
                parent = black
                grandfather = red
                leftRotate(grandfather)
    root = black // восстанавливаем свойство корня 

Удаление вершины

При удалении вершины могут возникнуть три случая в зависимости от количества её детей:

    Если у вершины нет детей, то изменяем указатель на неё у родителя на nil.
    Если у неё только один ребёнок, то делаем у родителя ссылку на него вместо этой вершины.
    Если же имеются оба ребёнка, то находим вершину со следующим значением ключа. У такой вершины нет левого ребёнка (так как такая вершина находится в правом поддереве исходной вершины и она самая левая в нем, иначе бы мы взяли ее левого ребенка. Иными словами сначала мы переходим в правое поддерево, а после спускаемся вниз в левое до тех пор, пока у вершины есть левый ребенок). Удаляем уже эту вершину описанным во втором пункте способом, скопировав её ключ в изначальную вершину.

Проверим балансировку дерева. Так как при удалении красной вершины свойства дерева не нарушаются, то восстановление балансировки потребуется только при удалении чёрной. Рассмотрим ребёнка удалённой вершины.

    Если брат этого ребёнка красный, то делаем вращение вокруг ребра между отцом и братом, тогда брат становится родителем отца. Красим его в чёрный, а отца — в красный цвет, сохраняя таким образом черную высоту дерева. Хотя все пути по-прежнему содержат одинаковое количество чёрных узлов, сейчас x имеет чёрного брата и красного отца. Таким образом, мы можем перейти к следующему шагу.

        Untitled-3.png

    Если брат текущей вершины был чёрным, то получаем три случая:
        Оба ребёнка у брата чёрные. Красим брата в красный цвет и рассматриваем далее отца вершины. Делаем его черным, это не повлияет на количество чёрных узлов на путях, проходящих через b, но добавит один к числу чёрных узлов на путях, проходящих через x, восстанавливая тем самым влиянние удаленного чёрного узла. Таким образом, после удаления вершины черная глубина от отца этой вершины до всех листьев в этом поддереве будет одинаковой.

            Untitled-4.png

        Если у брата правый ребёнок чёрный, а левый красный, то перекрашиваем брата и его левого сына и делаем вращение. Все пути по-прежнему содержат одинаковое количество чёрных узлов, но теперь у x есть чёрный брат с красным правым потомком, и мы переходим к следующему случаю. Ни x, ни его отец не влияют на эту трансформацию.

            Untitled-5.png

        Если у брата правый ребёнок красный, то перекрашиваем брата в цвет отца, его ребёнка и отца — в чёрный, делаем вращение. Поддерево по-прежнему имеет тот же цвет корня, поэтому свойство 3 и 4 не нарушаются. Но у x теперь появился дополнительный чёрный предок: либо a стал чёрным, или он и был чёрным и b был добавлен в качестве чёрного дедушки. Таким образом, проходящие через x пути проходят через один дополнительный чёрный узел. Выходим из алгоритма.

            Untitled-6.png

Продолжаем тот же алгоритм, пока текущая вершина чёрная и мы не дошли до корня дерева. Из рассмотренных случаев ясно, что при удалении выполняется не более трёх вращений.

Псевдокод:

func delete(key)
    Node p = root
    // находим узел с ключом key
    while p.key != key 
        if p.key < key 
            p = p.right
        else
            p = p.left
    if у p нет детей
        if p — корень
            root = nil
        else
            ссылку на p у "отца" меняем на nil
        return
    Node y = nil
    Node q = nil
    if один ребенок
        ссылку на у от "отца" меняем на ребенка y
    else
        // два ребенка
        y = вершина, со следующим значением ключа // у нее нет левого ребенка 
        if y имеет правого ребенка
            y.right.parent = y.parent
        if y — корень
            root = y.right
        else
            у родителя ссылку на y меняем на ссылку на первого ребенка y
    if y != p
        p.colour = y.colour
        p.key = y.key
    if y.colour == black
        // при удалении черной вершины могла быть нарушена балансировка
        fixDeleting(q)

func fixDeleting(p: Node)
    // далее родственные связи относительно p
    while p — черный узел и не корень
         if p — левый ребенок
             if "брат" красный 
                 brother = black
                 parent = red
                 leftRotate(parent)
             if у "брата" черные дети             // случай 1: "брат" красный с черными детьми
                 brother = red
             else
                 if правый ребенок "брата" черный // случай, рассматриваемый во втором подпункте:
                     brother.left = black         // "брат" красный с черными правым ребенком
                     brother = red
                     rightRotate(brother)
                 brother.colour = parent.colour   // случай, рассматриваемый в последнем подпункте
                 parent = black
                 brother.right = black
                 leftRotate(parent)
                 p = root
         else // p — правый ребенок
             // все случаи аналогичны тому, что рассмотрено выше
             if "брат" красный 
                 brother = black
                 parent = red
                 rightRotate(p.parent)
             if у "брата" черные дети
                 brother = red
             else
                 if левый ребенок "брата" черный
                     brother.right = black
                     brother = red
                     leftRotate(brother);
                 brother = parent
                 parent = black
                 brother.left = black
                 rightRotate(p.parent)
                 p = root
      p = black
      root = black

Объединение красно-чёрных деревьев

Объединение двух красно-чёрных деревьев T1 и T2 по ключу k возвращает дерево с элементами из T2, T1 и k. Требование: ключ k — разделяющий. То есть ∀k1∈T1,k2∈T2:k1⩽k⩽k2.

Если оба дерева имеют одинаковую черную высоту, то результатом будет дерево с черным корнем k, левым и правым поддеревьями k1 и k2 соответствено.

Теперь пусть у T1 черная высота больше (иначе аналогично).

    Находим в дереве T1 вершину y на черной высоте, как у дерева T2 вершину с максимальным ключом. Это делается несложно (особенно если мы знаем черную высоту дерева): спускаемся вниз, поддерживая текущую черную высоту.

        Идем вправо. Когда высота станет равной высоте T2, остановимся.
        Заметим, что черная высота T2⩾2. Поэтому в дереве T1 мы не будем ниже, чем 2. Пусть мы не можем повернуть направо (сын нулевой), тогда наша высота 2 (если мы в черной вершине) или 1 (если в красной). Второго случая быть не может, ибо высота T2⩾2, а в первом случае мы должны были завершить алгоритм, когда пришли в эту вершину.
        Очевидно, мы окажемся в черной вершине (ибо следующий шаг даст высоту меньше). Очевидно, мы оказались на нужной высоте.
        Теперь пусть мы попали не туда. То есть существует путь от корня до другой вершины. Посмотрим на то место, где мы не туда пошли. Если мы пошли вправо, а надо бы влево, то x имеет больший ключ (по свойству дерева поиска). А если пошли влево, а не вправо, значит правого сына и нет (точнее, есть, но он нулевой), значит в правом поддереве вообще нет вершин.
        Более того, все вершины с высотами меньше y, которые имеют ключ больше y, будут находиться в поддереве y. Действительно, мы всегда идем вправо. Инвариант алгоритма на каждом шаге — в поддереве текущей вершины содержатся все вершины, ключ которых больше текущего. Проверяется очевидно.
        Еще поймем, как будем хранить черную высоту дерева. Изначально она нулевая (в пустом дереве). Далее просто поддерживаем ее при операциях вставки и удаления.

    Объединим поддерево. k будет корнем, левым и правым сыновьями будут Ty и T2 соответственно.

        Покажем, что свойства дерева поиска не нарушены.
        Так как все ключи поддерева y не более k и все ключи T2 не менее k, то в новом поддереве с корнем k свойства выполняются.
        Так как k больше любого ключа из T1, то выполняется и для всего дерева.

    Красим k в красный цвет. Тогда свойство 4 будет выполнено. Далее поднимаемся вверх, как во вставке операциях, поворотами исправляя нарушение правила 3.
    В конце корень красим в черный, если до этого был красный (это всегда можно сделать, ничего не нарушив). 

Псевдокод:

func join(T_1, T_2, k)
    if черные высоты равны
        return Node(k, black, T_1, T_2)
    if высота T_1 больше
        T' = joinToRight(T_1, T_2, k)
        T'.color = black
        return T'
    else
        T' = joinToLeft(T_1, T_2, k)
        T'.color = black
        return T'

func joinToRight(T_1, T_2, k)
    Y = find(T_1, bh(T_2))
    T' = Node(k, red, Y, T_2)
    while нарушение
        действуем как во вставке
    return T'

func find(T, h)
    curBH = bh(T)
    curV = T
    while curBH != h
        curV = curV.right
        if curV.color == black
            --curBH
    return curV

Сложность: O(T1.h−T2.h)=O(log⁡(n))
Разрезание красно-чёрного дерева

Разрезание дерева по ключу k вернет два дерева, ключи первого меньше k, а второго — не меньше.

Пройдем вниз как во время поиска. Все левые поддеревья вершин пути, корень которых не в пути, будут в первом поддереве. Аналогично правые — в правом. Теперь поднимаемся и последовательно сливаем деревья справа и слева с ответами.

За счет того, что функция join работает за разницу высот, и мы объединяем снизу, то, благодаря телескопическому эффекту на работу времени будут влиять только крайние слагаемые, которые порядка глубины дерева.

Псевдокод

func split(T, k)
    if T = nil
        return ⟨nil, nil⟩
    if k < T.key
      ⟨L',R'⟩ = split(L,k)
      return ⟨L',join(R',T.key,R)⟩
    else 
      ⟨L',R'⟩ = split(R,k)
      return ⟨join(L,T.key,L'),R)⟩

Сложность: O(log⁡(n))

Точно такой же алгоритм в разрезании AVL деревьев. Оно и понятно — нам нужна лишь корректная функция join, работающая за разницу высот.
Преимущества красно-чёрных деревьев

    Самое главное преимущество красно-черных деревьев в том, что при вставке выполняется не более O(1) вращений. Это важно, например, в алгоритме построения динамической выпуклой оболочки. Ещё важно, что примерно половина вставок и удалений произойдут задаром.
    Процедуру балансировки практически всегда можно выполнять параллельно с процедурами поиска, так как алгоритм поиска не зависит от атрибута цвета узлов.
    Сбалансированность этих деревьев хуже, чем у АВЛ, но работа по поддержанию сбалансированности в красно-чёрных деревьях обычно эффективнее. Для балансировки красно-чёрного дерева производится минимальная работа по сравнению с АВЛ-деревьями.
    Использует всего 1 бит дополнительной памяти для хранения цвета вершины. Но на самом деле в современных вычислительных системах память выделяется кратно байтам, поэтому это не является преимуществом относительно, например, АВЛ-дерева, которое хранит 2 бита. Однако есть реализации красно-чёрного дерева, которые хранят значение цвета в бите. Пример — Boost Multiindex. В этой реализации уменьшается потребление памяти красно-чёрным деревом, так как бит цвета хранится не в отдельной переменной, а в одном из указателей узла дерева.

Красно-чёрные деревья являются наиболее активно используемыми на практике самобалансирующимися деревьями поиска. В частности, ассоциативные контейнеры библиотеки STL(map, set, multiset, multimap) основаны на красно-чёрных деревьях. TreeMap в Java тоже реализован на основе красно-чёрных деревьев.
Связь с 2-3 и 2-4 деревьями
Изоморфизм деревьев

Красно-черные деревья изоморфны B-деревьям 4 порядка. Реализация B-деревьев трудна на практике, поэтому для них был придуман аналог, называемый симметричным бинарным B-деревом[1]. Особенностью симметричных бинарных B-деревьев является наличие горизонтальных и вертикальных связей. Вертикальные связи отделяют друг от друга разные узлы, а горизонтальные соединяют элементы, хранящиеся в одном узле B-дерева. Для различения вертикальных и горизонтальных связей вводится новый атрибут узла — цвет. Только один из элементов узла в B-дереве красится в черный цвет. Горизонтальные связи ведут из черного узла в красный узел, а вертикальные могут вести из любого узла в черный.

Rbtree.png
Корректность сопоставления деревьев

Сопоставив таким образом цвета узлам дерева, можно проверить, что полученное дерево удовлетворяет всем свойствам красно-черного дерева.
Утверждение:

У красного узла родитель не может быть красного цвета.
▹
В узле 2-4 дерева содержится не более трех элементов, один из которых обязательно красится в черный при переходе к симметричному бинарному B-дереву. Тогда оставшиеся красные элементы, если они есть, подвешиваются к черному. Из этих элементов могут идти ребра в следующий узел 2-4 дерева. В этом узле обязательно есть черная вершина, в нее и направляется ребро. Оставшиеся элементы узла, если они есть, подвешиваются к черной вершине аналогично первому узлу. Таким образом, ребро из красной вершины никогда не попадает в красную, значит у красного элемента родитель не может быть красным.
◃
Утверждение:

Число черных узлов на любом пути от листа до вершины одинаково.
▹
В B-дереве глубина всех листьев одинакова, следовательно, одинаково и количество внутренних узлов на каждом пути. Мы сопоставляем чёрный цвет одному элементу внутреннего узла B-дерева. Значит, количество чёрных элементов на любом пути от листа до вершины одинаково.
◃
Утверждение:

Корень дерева — черный.
▹
Если в корне один элемент, то он — чёрный. Если же в корне несколько элементов, то заметим, что один элемент окрашен в чёрный цвет, остальные — в красный. Горизонтальные связи, соединяющие элементы внутри одного узнала, ведут из чёрного элемента в красный, следовательно, красные элементы будут подвешены к чёрному. Он и выбирается в качестве корня симметричного бинарного B-дерева.
◃
Сопоставление операций в деревьях

Все операции, совершаемые в B-дереве, сопоставляются операциям в красно-черном дереве. Для этого достаточно доказать, что изменение узла в B-дереве соответствует повороту в красно-черном дереве.
Утверждение:

Изменение узла в B-дереве соответствует повороту в красно-черном дереве.
▹

В 2-4 дереве изменение узла необходимо при добавлении к нему элемента. Рассмотрим, как будет меняться структура B-дерева и, соответственно, красно-черного дерева при добавлении элемента:

    Если в узле содержался один элемент, то происходит добавление второго элемента, соответствующее добавлению красного элемента в красно-черное дерево.

    Если в узле содержалось два элемента, то происходит добавление третьего элемента, что соответствует повороту и перекрашиванию вершин в красно-черном дереве.

    Если в узле содержалось три элемента, то один из элементов узла становится самостоятельным узлом, к которому подвешиваются узел из пары элементов и узел из одного элемента. Эта операция соответствует перекрашиванию яруса красно-черного дерева из красного в черный цвет.

Rbtree2.png
При удалении элемента из узла B-дерева совершаются аналогичные процессы поворота и окраски вершин в красно-черном дереве, только в обратном направлении. Так как все операции в 2-4 дереве происходят за счет изменения узлов, то они эквивалентны соответствующим операциям в красно-черном дереве.
◃
Теорема:

Приведенное выше сопоставление B-деревьев и красно-черных деревьев является изоморфизмом.
Доказательство:
▹
Доказательство следует непосредственно из приведенных выше утверждений.
◃
См. также

    Дерево поиска, наивная реализация
    АВЛ-дерево
    2-3 дерево

Примечания

    Перейти ↑ Абстрактные типы данных — Красно-чёрные деревья (Red black trees)

Источники информации

    Википедия — Красно-чёрное дерево
    AlgoList — Красно-черные деревья
    Lectures.stargeo — Конспект лекций
    Курс kiev-clrs — Лекция 10. Красно-чёрные деревья
    Визуализатор
    Абстрактные типы данных — Красно-чёрные деревья (Red black trees)

