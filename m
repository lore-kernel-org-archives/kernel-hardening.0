MIME-Version: 1.0
In-Reply-To: <20180117200532.GX13338@ZenIV.linux.org.uk>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com> <20180117185232.GW13338@ZenIV.linux.org.uk>
 <CAPcyv4iYVcCZxdd5wHDf2av8F=E1F7UGTX9uVzX68KkrJ1ZuQQ@mail.gmail.com> <20180117200532.GX13338@ZenIV.linux.org.uk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jan 2018 12:14:22 -0800
Message-ID: <CAPcyv4gHVSZjCHckGF+aTK3pN6FRY7KcsBtsMvXLZrZvzFwMVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 17, 2018 at 12:05 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Jan 17, 2018 at 11:54:12AM -0800, Dan Williams wrote:
>> On Wed, Jan 17, 2018 at 10:52 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Wed, Jan 17, 2018 at 02:17:26PM +0000, Alan Cox wrote:
>> [..]
>> >         Incidentally, what about copy_to_iter() and friends?  They
>> > check iov_iter flavour and go either into the "copy to kernel buffer"
>> > or "copy to userland" paths.  Do we need to deal with mispredictions
>> > there?  We are calling a bunch of those on read()...
>> >
>>
>> Those should be protected by the conversion of __uaccess_begin to
>> __uaccess_begin_nospec that includes the lfence.
>
> Huh?  What the hell does it do to speculative execution of "memcpy those
> suckers" branch?

'raw_copy_from_user 'is changed to use 'uaccess_begin_nospec' instead
of plain 'uacess_begin'. The only difference between those being that
the former includes an lfence. So with this sequence.

        if (access_ok(VERIFY_READ, from, n)) {
                kasan_check_write(to, n);
                n = raw_copy_from_user(to, from, n);
        }
        return n;

...'from' is guaranteed to be within the address limit with respect to
speculative execution, or otherwise never de-referenced.
