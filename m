MIME-Version: 1.0
From: Kees Cook <keescook@google.com>
Date: Mon, 26 Jun 2017 14:04:01 -0700
Message-ID: <CAGXu5jLCAdPOKZFotaWZ8MjwqW8Eq9_tLc_fgbYsTcbVWv77AQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] non-x86 per-task stack canaries
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

The stack protector functionality on x86_64 uses %gs:0x28 (%gs is the
percpu area) for __stack_chk_guard, and all other architectures use a
global variable instead. This means we never change the stack canary
on non-x86 architectures which allows for a leak in one task to expose
the canary in another task.

I'm curious what thoughts people may have about how to get this
correctly implemented. Teaching the compiler about per-cpu data sounds
exciting. :)

-Kees

-- 
Kees Cook
Pixel Security
