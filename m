Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: David Windsor <dwindsor@gmail.com>
Date: Sat, 29 Oct 2016 01:05:29 -0400
Message-ID: <CAEXv5_iWUUs-NwzJn7n38cX0R_Mdd2V4+T6E16akwrAMqhsuiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Expanding HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I've created a branch on Elena's github repo called
hardened_atomic_on_next_expanded
(https://github.com/ereshetova/linux-stable/tree/hardened_atomic_on_next_expanded)
which incorporates the PAX_REFCOUNT changes to extend atomic_t
coverage to kernel reference counters that were originally integer
types.  Our work to this point only addresses existing atomic_t users:
this patch is a first attempt to convert non-atomic_t reference
counter users to use atomic_t, and thus get overflow protection.

The users addressed in this branch are:
  * struct fs_struct.users
  * struct tty_port.count
  * struct tty_ldisc_ops.refcount
  * struct pipe_inode_info.{readers|writers|files|waiting_writers}
  * struct kmem_cache.refcount

This branch currently does not compile, as I am in the process of
cherrypicking the necessary changes from PAX_REFCOUNT.

I wanted to let Elena/Hans know about this now, as they are preparing
the next RFC.  I don't know if we want to actually expand kernel
coverage in this round of RFC's, but there shouldn't be much more work
left to get this working.

Thanks,
David
