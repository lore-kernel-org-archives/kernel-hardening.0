MIME-Version: 1.0
In-Reply-To: <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com> <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Jan 2018 20:30:17 -0800
Message-ID: <CAPcyv4g94iysWqz64KNk=HDdx6+b2e0O-rRrnFZDqfNSR3Xrjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 16, 2018 at 2:23 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sat, Jan 13, 2018 at 11:33 AM, Linus Torvalds
[..]
> I'll respin this set along those lines, and drop the ifence bits.

So now I'm not so sure. Yes, get_user_{1,2,4,8} can mask the pointer
with the address limit result, but this doesn't work for the
access_ok() + __get_user() case. We can either change the access_ok()
calling convention to return a properly masked pointer to be used in
subsequent calls to __get_user(), or go with lfence on every
__get_user call. There seem to be several drivers that open code
copy_from_user() with __get_user loops, so the 'fence every
__get_user' approach might have noticeable overhead. On the other hand
the access_ok conversion, while it could be scripted with coccinelle,
is ~300 sites (VERIFY_READ), if you're concerned about having
something small to merge for 4.15.

I think the access_ok() conversion to return a speculation sanitized
pointer or NULL is the way to go unless I'm missing something simpler.
Other ideas?
