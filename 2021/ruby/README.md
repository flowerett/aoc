### Ruby

Ruby doesn't like recursions, if you really need it,
you can increase stack size:

```sh
RUBY_THREAD_VM_STACK_SIZE=10000000 ./dayx.rb
```

There are bugs in different ruby versions with it,
but `ruby 2.7.4` should work.