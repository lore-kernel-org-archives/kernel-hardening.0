MIME-Version: 1.0
In-Reply-To: <1516976647.5438.6.camel@linux.intel.com>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
 <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
 <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
 <CA+55aFwUn7+WiHxL7PBWxNrGB0--HETqUjdRwxi+DkMvCP_CaA@mail.gmail.com>
 <CALCETrV1JHK1ovjjD1vbs08K1an6tq6nbRoAj9uyrY2GUYJJBA@mail.gmail.com>
 <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
 <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com>
 <b8ea504729db4073abf82ebd5d8a53c6@AcuMS.aculab.com> <1516976647.5438.6.camel@linux.intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 26 Jan 2018 07:57:35 -0800
Message-ID: <CALCETrXaARjGa+fCmxDDYNQCgv0ZSm+DaUFoXFmRxU9J245HxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Alan Cox <alan@linux.intel.com>
Cc: David Laight <David.Laight@aculab.com>, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 26, 2018 at 6:24 AM, Alan Cox <alan@linux.intel.com> wrote:
>> NetBSD (and the other BSD?) defines a structure for the arguments to
>> each syscall.
>
> Goes back to v7 or so but they put the syscall arguments into the uarea
> so that no pointers were needed (uarea being a per process mapping at a
> fixed address) in order to also reduce pointer dereferencing costs (not
> that those matter much on modern processors)
>

I gave the rearrangement like this a try yesterday and it's a bit of a
mess.  Part of the problem is that there are a bunch of pieces of code
that expect sys_xyz() to be actual callable functions.  The best way
to deal with that is probably to switch to calling normal functions.
