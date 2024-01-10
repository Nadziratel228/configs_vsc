//text  files
FILE *inp, *otp;
inp = fopen("input.txt", "r+");
otp = fopen("output.txt", "w+");
fscanf(inp, "%d%d", &N, &M); //дает EOF если конец файла
fgets(string, n, inp) //дает NULL если не вышло считать
fprintf(otp, " ", ...)
fputs(string, otp)
fclose(inp)
fclose(otp)
//binary files
FILE *inp_b = fopen("input.bin", "rb");
FILE *otp_b = fopen("output.bin", "wb");
fread(указателькудачитать, размертипа, сколькоячеек, inp_b)//дает 0 если не вышло считать
fwrite(указателькудаписать, размертипа, сколькоячеек, otp_b)


//приоритеты операций
1) постфиксные++ --, ()_вызов функции, []_индексация, . и -> в структурах, составной литерал || слева направо
2) префиксные++ --, унарные + и -, логическое и побитовое не (! и ~), приведение к типу, разыменование указателя и взятие адреса, sizof и alignof || справа налево
3)* / % (арифметика) || слева направо
4) + - || слева направо
5) << >>  сдвиги || справа налево 
6) < <= > >= сравнения || слева направо 
7) == != сравнения || слева направо 
8)& побитовое и || слева направо
9)^ побитовое искл. или || слева направо
10) | побитовое или || слева направо
11) && логическое и || слева направо
12) || логическое или || слева направо
13) ? : тернарник || справа налево
14) = += -= *= /= %= <<= >>= &= ^= |= присваивания || справа налево
15) , запятая || слева направо

//типы выражений (широк в смысле int < long < long long)
1) если один из операндов long double, то второй приводится к нему
2) иначе, если один double, то второй приводится к нему
3) иначе, если один float, то второй приводится к нему
4) иначе оба операнда целые и происходит целочисленное расширение. всякий тип не шире инта приводится к инту, если все его значения выражаются в инте, иначе к unsigned int.
далее:
-если оба одновременно знаковые или беззнаковые, то более узкий к более широкому
-иначе если беззнаковый тип не менее широк чем знаковый, то оба к беззнаковому
-иначе если тип знакового представляет все значения беззнакового, то оба к знаковому
-иначе оба к беззнаковому, который соответствует типу знакового

разность указателей ptrdiff_t, размер size_t

//префикс-функция
void prefix_func(char *s, int *pi, int n)
{
    for (int i = 1; i < n; ++i) {
        int j = pi[i - 1];
        while (j > 0 && s[i] != s[j])
            j = pi[j - 1];
        if (s[i] == s[j])
            pi[i] = ++j;
    }
}


//linked list
typedef struct list_node {
  int value;
  struct list_node *next;
} lnode;

lnode *pushback_list(lnode **tail, int val) {
  lnode *new_node = calloc(1, sizeof(struct list_node));
  if (*tail)
    (*tail)->next = new_node;
  *tail = new_node;
  new_node->value = val;
  new_node->next = NULL;
  return new_node;
}

void free_list(lnode *head) {
  if (!head)
    return;
  lnode *buff;
  while (head->next) {
    buff = head->next;
    free(head);
    head = buff;
  }
  return;
}

int in_list(lnode *head, int key) {
  if (!head)
    return 0;
  while (head->next) {
    if (head->value == key)
      return 1;
    head = head->next;
  }
  if (head->value == key)
    return 1;
  return 0;
}

void print_list(lnode *head, FILE *otp) {
  if (head)
    while (head) {
      fprintf(otp, "%d", head->value);
      head = head->next;
      if (head)
        fprintf(otp, " ");
    }
  return;
}



//stack

typedef struct item_in_stack
{
    int item;
    struct item_in_stack *next;
} stack_item;

void
stack_add(stack_item **stack, lnode *item)
{
    stack_item *new_stack_item = calloc(1, sizeof(stack_item));
    new_stack_item->next = *stack;
    new_stack_item->item = item;
    *stack = new_stack_item;
}

lnode *
stack_pop(stack_item **stack)
{
    if (!(*stack)) {
        return NULL;
    }
    stack_item *buff = *stack;
    lnode *ans = (*stack)->item;
    *stack = (*stack)->next;
    free(buff);
    return ans;
}

//очередб на стеках (на списках очев)
Процедура enqueue(x):
    S1.push(x)

Функция dequeue():
    если S2 пуст:
        если S1 пуст:
            сообщить об ошибке: очередь пуста

        пока S1 не пуст:
            S2.push(S1.pop())

    вернуть S2.pop()

