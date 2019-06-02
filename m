MIME-Version: 1.0
References: <20190601222738.6856-1-joel@joelfernandes.org> <20190601222738.6856-3-joel@joelfernandes.org>
 <20190602070014.GA543@amd>
In-Reply-To: <20190602070014.GA543@amd>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Sun, 2 Jun 2019 08:20:15 -0400
Message-ID: <CAEXW_YT3t4Hb6wKsjXPGng+YbA5rhNRa7OSdZwdN4AKGfVkX3g@mail.gmail.com>
Subject: Re: [RFC 2/6] ipv4: add lockdep condition to fix for_each_entry
Content-Type: text/plain; charset="UTF-8"
To: Pavel Machek <pavel@denx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Neil Brown <neilb@suse.com>, netdev <netdev@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zilstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu <rcu@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 2, 2019 at 3:00 AM Pavel Machek <pavel@denx.de> wrote:
>
> On Sat 2019-06-01 18:27:34, Joel Fernandes (Google) wrote:
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>
> This really needs to be merged to previous patch, you can't break
> compilation in middle of series...
>
> Or probably you need hlist_for_each_entry_rcu_lockdep() macro with
> additional argument, and switch users to it.

Good point. I can also just add a temporary transition macro, and then
remove it in the last patch. That way no new macro is needed.

Thanks!
