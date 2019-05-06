MIME-Version: 1.0
From: Allen <allen.lkml@gmail.com>
Date: Mon, 6 May 2019 15:02:38 +0530
Message-ID: <CAOMdWSLNUEMux1hXfWP+oxZ3YG=uycDmAomGA1iTxjfyOYA0WQ@mail.gmail.com>
Subject: [RFC] refactor tasklets to avoid unsigned long argument
Content-Type: text/plain; charset="UTF-8"
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>, tglx@linuxtronix.de
List-ID: <kernel-hardening.lists.openwall.com>

All,

  I have been toying with the idea of "refactor tasklets to avoid
unsigned long argument" since Kees listed on KSPP wiki. I wanted to
and have kept the implementation very simple. Let me know what you
guys think.

Note: I haven't really done much of testing besides boot testing with small
set of files moved to the new api.

  My only concern with the implementation is, in the kernel the combination
of tasklet_init/DECLARE_TAKSLET is seen in over ~400 plus files.
With the change(dropping unsigned long argument) there will be huge list
of patches migrating to the new api.

Below is the diff of the change:

Signed-off-by: Allen Pais <allen.lkml@gmail.com>

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 690b238a44d5..5e58df52970f 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -589,16 +589,17 @@ struct tasklet_struct
        struct tasklet_struct *next;
        unsigned long state;
        atomic_t count;
-       void (*func)(unsigned long);
-       unsigned long data;
+       void (*func)(struct tasklet_struct *);
 };

-#define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
+#define DECLARE_TASKLET(name, func) \
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func }

-#define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
+#define DECLARE_TASKLET_DISABLED(name, func) \
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func }

+#define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
+       container_of(callback_tasklet, typeof(*var), tasklet_fieldname)

 enum
 {
@@ -666,7 +667,7 @@ static inline void tasklet_enable(struct tasklet_struct *t)
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
-                        void (*func)(unsigned long), unsigned long data);
+                        void (*func)(struct tasklet_struct *));

 struct tasklet_hrtimer {
        struct hrtimer          timer;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 10277429ed84..923a76be6038 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -521,7 +521,7 @@ static void tasklet_action_common(struct softirq_action *a,
                                if (!test_and_clear_bit(TASKLET_STATE_SCHED,
                                                        &t->state))
                                        BUG();
-                               t->func(t->data);
+                               t->func(t);
                                tasklet_unlock(t);
                                continue;
                        }
@@ -548,13 +548,12 @@ static __latent_entropy void
tasklet_hi_action(struct softirq_action *a)
 }

 void tasklet_init(struct tasklet_struct *t,
-                 void (*func)(unsigned long), unsigned long data)
+                 void (*func)(struct tasklet_struct *))
 {
        t->next = NULL;
        t->state = 0;
        atomic_set(&t->count, 0);
        t->func = func;
-       t->data = data;
 }
 EXPORT_SYMBOL(tasklet_init);

@@ -595,9 +594,9 @@ static enum hrtimer_restart
__hrtimer_tasklet_trampoline(struct hrtimer *timer)
  * Helper function which calls the hrtimer callback from
  * tasklet/softirq context
  */
-static void __tasklet_hrtimer_trampoline(unsigned long data)
+static void __tasklet_hrtimer_trampoline(struct tasklet_struct *t)
 {
-       struct tasklet_hrtimer *ttimer = (void *)data;
+       struct tasklet_hrtimer *ttimer = from_tasklet(ttimer, t, tasklet);
        enum hrtimer_restart restart;

        restart = ttimer->function(&ttimer->timer);
@@ -618,8 +617,7 @@ void tasklet_hrtimer_init(struct tasklet_hrtimer *ttimer,
 {
        hrtimer_init(&ttimer->timer, which_clock, mode);
        ttimer->timer.function = __hrtimer_tasklet_trampoline;
-       tasklet_init(&ttimer->tasklet, __tasklet_hrtimer_trampoline,
-                    (unsigned long)ttimer);
+       tasklet_init(&ttimer->tasklet, __tasklet_hrtimer_trampoline);
        ttimer->function = function;
 }
 EXPORT_SYMBOL_GPL(tasklet_hrtimer_init);


Couple of diffs where the files have been moved to the new api:

1.
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 5cc608de6883..64b8fbff3c1a 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -1010,13 +1010,13 @@ static void kgdb_unregister_callbacks(void)
  * such as is the case with kgdboe, where calling a breakpoint in the
  * I/O driver itself would be fatal.
  */
-static void kgdb_tasklet_bpt(unsigned long ing)
+static void kgdb_tasklet_bpt(struct tasklet_struct *t)
 {
        kgdb_breakpoint();
        atomic_set(&kgdb_break_tasklet_var, 0);
 }

-static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);
+static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);

 void kgdb_schedule_breakpoint(void)
 {

2.
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index f8c703426c90..0c3e924c0a48 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1524,9 +1524,9 @@ static irqreturn_t eni_int(int irq,void *dev_id)
 }

-static void eni_tasklet(unsigned long data)
+static void eni_tasklet(struct tasklet_struct *t)
 {
-       struct atm_dev *dev = (struct atm_dev *) data;
+       struct atm_dev *dev = from_tasklet(dev, t, tasklet);
        struct eni_dev *eni_dev = ENI_DEV(dev);
        unsigned long flags;
        u32 events;
@@ -1841,7 +1841,7 @@ static int eni_start(struct atm_dev *dev)
             eni_dev->vci,eni_dev->rx_dma,eni_dev->tx_dma,
             eni_dev->service,buf);
        spin_lock_init(&eni_dev->lock);
-       tasklet_init(&eni_dev->task,eni_tasklet,(unsigned long) dev);
+       tasklet_init(&eni_dev->task,eni_tasklet);
        eni_dev->events = 0;
        /* initialize memory management */
        buffer_mem = eni_dev->mem - (buf - eni_dev->ram);


 - Allen
