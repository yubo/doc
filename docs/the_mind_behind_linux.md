## The mind behind Linux - Linus Torvalds 
- 这个，第一段不怎么漂亮的代码，基本上是再你刚开始学编程的时候遇到的，你不需要真的理解这段代码。
- This, the first not very good taste approach, is basically how it's taught to be done when you start out coding. And you don't have to understand the code.

```c
remove_list_entry(entry)
{
	prev = NULL;
	walk = head;

	// Walk the list

	while (walk != entry) {
		prev = walk;
		walk = walk->next;
	}

	// Remove the entry by updating the
	// head or the previous entry

	if (!prev)
		head = entry->next;
	else
		prev->next = entry->next;
}
```

- 我觉得最有意思的是最后一个"if"语句。因为，在单向链表中移除某个节点时，节点在链表的起始位置和在中间位置，情况会有所不同。当出现在起始位置时，需要修改链表指针；如果在中间，则需要修改前一个节点的指针。这是两种完全不同的情况。
- The most interesting part to me is the last if statement. Because what happens in a singly-linked list -- this is trying to remove an existing entry from a list -- and there's a difference between if it's the first entry or whether it's an entry in the middle. Because if it's the first entry, you have to change the pointer to the first entry. If it's in the middle, you have to change the pointer of a previous entry. So they're two completely different cases.

```c
remove_list_entry(entry)
{
	// The "indirect" pointer poins to the
	// *address* of the thins we'll update

	indirect = &head;

	// Walk the list, looking for the thing that
	// points to the entry we want to remove

	while ((*indirect) != entry)
		indirect = &(*indirect)->next;

	// .. and just remove it
	*indirect = entry->next;
}
```

- 这个就更好些，它没有if判断，这完全不影响，你不必了解这里为什么没有"if"语句，你需要了解的是，有时候你可以换个角度看问题，重写代码，排除特例，完美覆盖所有情况。这就是好的代码。同时也很简单。这是最基本的原则(cs101)。其实这都不重要，当然，细节非常重要。。
- And this is better. It does not have the if statement. And it doesn't really matter -- I don't want you understand why it doesn't have the if statement, but I want you to understand that sometimes you can see a problem in a different way and rewrite it so that a special case goes away and becomes the normal case. And that's good code. But this is simple code. This is CS 101. This is not important -- although, details are important.

- 对我来说，我愿意与之共事的人，必须有好的品味，这就是。。。(停顿) 我举得这个例子很傻，没什么意义，因为实在太短。好的品味体现在更长的代码里。好的品味体现在能看清全局。甚至有一种直觉，知道怎么把事情做漂亮。
- To me, the sign of people I really want to work with is that they have good taste, which is how ... I sent you this stupid example that is not relevant because it's too small. Good taste is much bigger than this. Good taste is about really seeing the big patterns and kind of instinctively knowing what's the right way to do things.

