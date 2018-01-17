Message-ID: <1516198646.4184.13.camel@linux.intel.com>
From: Alan Cox <alan@linux.intel.com>
Date: Wed, 17 Jan 2018 14:17:26 +0000
In-Reply-To: <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
References: 
	<151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
	 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
	 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
	 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
	 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE
 in get_user paths
To: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2018-01-16 at 14:41 -0800, Linus Torvalds wrote:
> 
> 
> On Jan 16, 2018 14:23, "Dan Williams" <dan.j.williams@intel.com>
> wrote:
> > That said, for get_user specifically, can we do something even
> > cheaper. Dave H. reminds me that any valid user pointer that gets
> > past
> > the address limit check will have the high bit clear. So instead of
> > calculating a mask, just unconditionally clear the high bit. It
> > seems
> > worse case userspace can speculatively leak something that's
> > already
> > in its address space.
> 
> That's not at all true.
> 
> The address may be a kernel address. That's the whole point of
> 'set_fs()'.

Can we kill off the remaining users of set_fs() ?

Alan
