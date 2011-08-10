Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 10 Aug 2011 14:02:27 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110810100227.GA3507@albatros>
References: <20110605194746.GA6484@albatros>
 <20110605201025.GA9541@openwall.com>
 <20110606180806.GA3986@albatros>
 <20110606183358.GA14711@openwall.com>
 <20110608172307.GA3380@albatros>
 <20110612023916.GC14976@openwall.com>
 <20110724185036.GC3510@albatros>
 <20110726145016.GA8583@albatros>
 <20110729174725.GA2339@albatros>
 <20110804112331.GA2563@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804112331.GA2563@albatros>
Subject: [kernel-hardening] Re: procfs {tid,tgid,attr}_allowed mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Thu, Aug 04, 2011 at 15:23 +0400, Vasiliy Kulikov wrote:
> New version.  Cleanups/fixes here and there.

One question: do we really need gid= option?  The only user I know is
identd, but does anybody use it nowadays?

With gid= I see 2 drawbacks:

1) Code becomes worse because of additional permission checks.

2) From the upstream's point of view it is very limited and unextendable
feature.


So, I'd go further without gid=, at least for the beginning.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
