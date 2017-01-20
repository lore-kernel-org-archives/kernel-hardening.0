Date: Fri, 20 Jan 2017 11:17:47 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170120111747.GB18576@leverpostej>
References: <20170119145114.GA19772@pjb1027-Latitude-E5410>
 <20170119155701.GA24654@leverpostej>
 <CAErMHp-L-B_9pWVRpqRSpH8LL4VEmHHrFDUbkvNZbXC=uWCzng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErMHp-L-B_9pWVRpqRSpH8LL4VEmHHrFDUbkvNZbXC=uWCzng@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] mm: add arch-independent testcases for RODATA
To: park jinbum <jinb.park7@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, akpm@linuxfoundation.org, keescook@chromium.org, linux-mm@kvack.org, arjan@linux.intel.com, mingo@redhat.com, tglx@linutronix.de, linux@armlinux.org.uk, kernel-janitors@vger.kernel.org, kernel-hardening@lists.openwall.com, labbott@redhat.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 20, 2017 at 03:49:46PM +0900, park jinbum wrote:
> Where is the best place for common test file in general??
> 
>  kernel/rodata_test.c
>  include/rodata_test.h => Is it fine??

I had assumed you would use mm/rodata_test.c, as you do in this patch
(i.e. a *new* common file). That seems fine to me.

Thanks,
Mark.
