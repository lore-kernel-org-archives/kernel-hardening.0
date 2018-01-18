MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180118030634.GY13338@ZenIV.linux.org.uk>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com> <20180117185232.GW13338@ZenIV.linux.org.uk>
 <20180118030634.GY13338@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Jan 2018 19:16:02 -0800
Message-ID: <CA+55aFzKPed+89wz=ajWNpsQ8Kh+AQWx61hwVqqDh7_=h4tecg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC][PATCH] get rid of the use of set_fs() (by way of
 kernel_recvmsg()) in sunrpc
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Network Development <netdev@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 17, 2018 at 7:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Similar to the way put_cmsg() handles 32bit case on biarch
> targets, introduce a flag telling put_cmsg() to treat
> ->msg_control as kernel pointer, using memcpy instead of
> copy_to_user().  That allows to avoid the use of kernel_recvmsg()
> with its set_fs().

If this is the only case that kernel_recvmsg() exists for, then by all
means, that patch certainly looks like a good thing.

                 Linus
