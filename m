Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 2 Aug 2011 14:29:25 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
Message-ID: <20110802142925.4a42a603@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20110802124530.GA2543@albatros>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E.
 McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2 Aug 2011 16:45:30 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> Manuel, Richard, Marc - can you test this patch, please?

Works fine here (tested on an EB11MP).

FWIW: Tested-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
I'm the slime oozin' out from your TV set...
