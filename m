Return-Path: <linux-api-owner@vger.kernel.org>
Date: Tue, 25 Jun 2019 13:08:07 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <201906251131.419D8ACB@keescook>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
Sender: linux-api-owner@vger.kernel.org
Subject: Re: Detecting the availability of VSYSCALL
Content-Transfer-Encoding: 8bit
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 25, 2019 at 05:15:27PM +0200, Florian Weimer wrote:
> Should we try mapping something at the magic address (without MAP_FIXED)
> and see if we get back a different address?  Something in the auxiliary
> vector would work for us, too, but nothing seems to exists there
> unfortunately.

It seems like mmap() won't even work because it's in the high memory
area. I can't map something a page under the vsyscall page either, so I
can't distinguish it with mmap, mprotect, madvise, or msync. :(

-- 
Kees Cook
