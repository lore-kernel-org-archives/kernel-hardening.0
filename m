Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Jun 2011 14:01:54 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110617100154.GA7885@albatros>
References: <20110617083651.GA5625@albatros>
 <20110617085951.GA7772@openwall.com>
 <20110617092551.GA6959@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617092551.GA6959@albatros>
Subject: Re: [kernel-hardening] How to temporary change 'current' (task)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2011 at 13:25 +0400, Vasiliy Kulikov wrote:
> On Fri, Jun 17, 2011 at 12:59 +0400, Solar Designer wrote:
> > On Fri, Jun 17, 2011 at 12:36:51PM +0400, Vasiliy Kulikov wrote:
> > > I wonder whether there is a simple way to temporary switch 'current' to
> > > another task and then switch it back with minimum side effects?

BTW, as HARDEN_PROC restricts not only procfs, but also netlink sockets,
it should be moved into sysctls.  I think about (according to already
implemented dmesg_restricted and kptr_restricted):

    kernel.proc_restricted

    kernel.proc_restricted_gid

And, as net restriction is no more associated with proc restrictions:

    net.core.conninfo_restricted

    net.core.conninfo_restricted_gid

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
