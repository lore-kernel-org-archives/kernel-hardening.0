Date: Thu, 26 Jul 2018 18:15:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Message-ID: <20180726181558.25a5c3b8@gandalf.local.home>
In-Reply-To: <CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
References: <20180725202238.165314-1-salyzyn@android.com>
	<20180725210717.3b807191@vmware.local.home>
	<11437c3e-5131-7190-c496-7b51eb7fcc2a@android.com>
	<20180726153153.GA8327@kroah.com>
	<CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: greg@kroah.com, Kees Cook <keescook@google.com>, salyzyn@android.com, LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, kernel-team@android.com, stable@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 26 Jul 2018 09:52:11 -0700
Nick Desaulniers <ndesaulniers@google.com> wrote:

> See the section "Kernel addresses" in
> Documentation/security/self-protection.  IIRC, the issue is that a
> process may have CAP_SYSLOG but not necessarily CAP_SYS_ADMIN (so it
> can read dmesg, but not necessarily issue a sysctl to change
> kptr_restrict), get compromised and used to leak kernel addresses,
> which can then be used to defeat KASLR.

But the code doesn't go to dmesg. It's only available
via /sys/kernel/debug/tracing/printk_formats which is only available
via root. Nobody else has access to that directory.

-- Steve
