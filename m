MIME-Version: 1.0
In-Reply-To: <CAPcyv4jn6xHNB2DevoFEzkfpnKCd7u8UdA+TmVPtbO08TjzFWA@mail.gmail.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CAPcyv4g94iysWqz64KNk=HDdx6+b2e0O-rRrnFZDqfNSR3Xrjg@mail.gmail.com>
 <20180117062800.GU13338@ZenIV.linux.org.uk> <CAPcyv4jn6xHNB2DevoFEzkfpnKCd7u8UdA+TmVPtbO08TjzFWA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jan 2018 10:12:06 -0800
Message-ID: <CAPcyv4gG-bftybBHcwhf-q17+byonQW4ymGzrJmsYAbzga8AxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 16, 2018 at 10:50 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Jan 16, 2018 at 10:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
[..]
>> Anything that open-codes copy_from_user() that way is *ALREADY* fucked if
>> it cares about the overhead - recent x86 boxen will have slowdown from
>> hell on stac()/clac() pairs.  Anything like that on a hot path is already
>> deep in trouble and needs to be found and fixed.  What drivers would those
>> be?
>
> So I took a closer look and the pattern is not copy_from_user it's
> more like __get_user + write-to-hardware loops. If the performance is
> already expected to be bad for those then perhaps an lfence each loop
> iteration won't be much worse. It's still a waste because the lfence
> is only needed once after the access_ok.
>
>> We don't have that many __get_user() users left outside of arch/*
>> anymore...

Given the concern of having something easy to backport first I think
we should start with lfence in __uaccess_begin(). Any deeper changes
to the access_ok() + __get_user calling convention can build on top of
that baseline.
