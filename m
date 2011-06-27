Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2011 02:37:12 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110627223712.GA8685@openwall.com>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com> <4E07F1C0.2070305@jp.fujitsu.com> <20110627070300.GA4463@albatros> <4E08324D.9040605@jp.fujitsu.com> <20110627085242.GA6635@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627085242.GA6635@albatros>
Subject: [kernel-hardening] Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
To: kernel-hardening@lists.openwall.com
Cc: Vasiliy Kulikov <segoon@openwall.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, eparis@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 27, 2011 at 12:52:42PM +0400, Vasiliy Kulikov wrote:
> As to random bytes - if it is very predictable (e.g. rand() % 10000) one
> may restore the original value.  But it would still do much harm to good
> programs (io stats going up and down!).  Adding really random bytes
> seems somewhat too complicated for these needs to me.

Random noise doesn't help very much even if it's totally unpredictable
and even if it's much louder than the signal.  It will only increase the
number of samples needed to see the signal through the noise.

More effective ways to deal with side-channel attacks are to make things
appear constant or, better yet, to remove the side-channel altogether
if possible.  I'd happily break iotop for non-admins on many of my
systems, so please give me a way to do it.

http://en.wikipedia.org/wiki/Side_channel_attack#Countermeasures

Alexander
