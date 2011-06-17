Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Jun 2011 14:11:49 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110617101149.GA8095@albatros>
References: <20110617083651.GA5625@albatros>
 <20110617085951.GA7772@openwall.com>
 <20110617092551.GA6959@albatros>
 <20110617100154.GA7885@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617100154.GA7885@albatros>
Subject: Re: [kernel-hardening] How to temporary change 'current' (task)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2011 at 14:01 +0400, Vasiliy Kulikov wrote:
>     kernel.proc_restricted
> 
>     kernel.proc_restricted_gid

Or even kernel.procinfo_restricted{,gid}.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
