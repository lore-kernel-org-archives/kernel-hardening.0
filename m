Reply-To: kernel-hardening@lists.openwall.com
From: Richard Weinberger <richard@nod.at>
Date: Tue, 2 Aug 2011 15:23:56 +0200
References: <20110801180151.GA26686@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com> <20110802124530.GA2543@albatros>
In-Reply-To: <20110802124530.GA2543@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108021523.56483.richard@nod.at>
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Marc Zyngier <maz@misterjones.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Dienstag 02 August 2011 14:45:30 Vasiliy Kulikov wrote:
> Hi,
> 
> Manuel, Richard, Marc - can you test this patch, please?
> 

Works fine. :-)

Tested-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
