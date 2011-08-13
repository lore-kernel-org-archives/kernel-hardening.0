Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 13 Aug 2011 21:31:18 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110813173118.GA1639@albatros>
References: <20110810142609.GA31434@openwall.com>
 <20110810150257.GA12198@albatros>
 <20110810154059.GA31860@openwall.com>
 <20110810162101.GA2833@albatros>
 <20110810164225.GA32177@openwall.com>
 <20110812120747.GA14598@albatros>
 <20110812122343.GA7859@openwall.com>
 <20110813151220.GA8388@albatros>
 <20110813151947.GA12495@openwall.com>
 <20110813165502.GA9328@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813165502.GA9328@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Aug 13, 2011 at 20:55 +0400, Vasiliy Kulikov wrote:
> Some thoughts about prctl() approach.

Also, to keep the code clean and small, I think sysctl interface should
be dropped.  The only use case is locking a live container, which is
probably a very limited thing.  Also it will fail if any unprivileged task
already runs a binary of other bitness anyway.

Do you agree?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
