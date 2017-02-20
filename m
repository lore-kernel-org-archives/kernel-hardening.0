Date: Mon, 20 Feb 2017 09:20:29 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-ID: <20170220082029.fiosdnwx7rauawgr@linutronix.de>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <1487498660-16600-5-git-send-email-hoeun.ryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1487498660-16600-5-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] Re: [RFC 5/7] cpu: mark ro_mostly_after_init for cpuhp_ap/bp_states
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-02-19 19:04:08 [+0900], Hoeun Ryu wrote:
> It would be good that `__ro_mostly_after_init` is marked to cpuhp state
> objects. 
why?

Sebastian
