Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1329845435-2313-3-git-send-email-wad@chromium.org>
References: <1329845435-2313-1-git-send-email-wad@chromium.org> <1329845435-2313-3-git-send-email-wad@chromium.org>
From: Roland McGrath <mcgrathr@google.com>
Date: Tue, 21 Feb 2012 10:46:53 -0800
Message-ID: <CAB=4xhp6y7Pq7mTF228TdyA-_z2j5z1yEnFrNQrFr7M9BZQ1Fg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v10 03/11] asm/syscall.h: add syscall_get_arch
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

> +void syscall_get_arch(struct task_struct *task, struct pt_regs *regs);

Bad return type.
