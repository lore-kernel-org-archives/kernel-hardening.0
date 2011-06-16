Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 16 Jun 2011 18:26:30 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110616142630.GA11442@albatros>
References: <20110614083559.GB7973@albatros>
 <20110615143844.GB32753@openwall.com>
 <20110615153845.GA10715@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615153845.GA10715@albatros>
Subject: Re: [kernel-hardening] HARDEN_VM86
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2011 at 19:38 +0400, Vasiliy Kulikov wrote:
> On Wed, Jun 15, 2011 at 18:38 +0400, Solar Designer wrote:
> > If upstream is fine with sysctl's setting gids, and this appears to be
> > the case, then let's go for this.
> 
> I see one problem with gid style - as gid is a per pid_namespace thing,
> it should be configurable per pid_namespace.
> 
> But on the other hand, a potential bug might lead to a privilege
> escalation (not a in-namespace root, but e.g. arbitrary write into any
> physical address) due to the nature of the syscall.  So, in-namespace
> root shouldn't be able to configure who is able to do vm86(2), otherwise
> it is able to gain full root.

With CAP_SYS_RAWIO there is no such problem in OpenVZ by default as
CAP_SYS_RAWIO is disabled in CT by default.  So, specifically for OpenVZ
I see the cap check as a more preferable one.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
