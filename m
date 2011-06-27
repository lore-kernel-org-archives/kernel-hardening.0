Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 27 Jun 2011 14:59:49 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110627105949.GA9260@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
 <4E07F1C0.2070305@jp.fujitsu.com>
 <20110627070300.GA4463@albatros>
 <4E08324D.9040605@jp.fujitsu.com>
 <20110627085242.GA6635@albatros>
 <4E08565C.4080007@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E08565C.4080007@jp.fujitsu.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, eparis@redhat.com, kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 27, 2011 at 19:07 +0900, KOSAKI Motohiro wrote:
> I'm ok any alternative way if you have. I only want to don't break iotop.
> It's used very widely and frequently from performance tuning engineers.

It doesn't break listening for own processes statistics.  It disables
spying for alien processes.  Or is iotop does something useful using
other users' processes information?  The only thing I can think about is
watching for the related processes running under the separate account
(e.g. separate DB and web user accounts).

For performance things IMO the precise io activity is needed anyway.  If
you have to watch for other processes, you probably have to be root
(which is overkill, though).


Don't know whether it can help - I've suggested the way to define a
group allowed to read somewhat private procfs files:

http://www.openwall.com/lists/kernel-hardening/2011/06/15/19

It is incomplete (in sense of taskstats missing) and it is a bit dumb/not
configurable.  Here I suggest a bit more configurable scheme:

http://www.openwall.com/lists/kernel-hardening/2011/06/22/1


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
