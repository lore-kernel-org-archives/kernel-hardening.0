Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 15 Jun 2011 19:38:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110615153845.GA10715@albatros>
References: <20110614083559.GB7973@albatros>
 <20110615143844.GB32753@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615143844.GB32753@openwall.com>
Subject: Re: [kernel-hardening] HARDEN_VM86
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Jun 15, 2011 at 18:38 +0400, Solar Designer wrote:
> If upstream is fine with sysctl's setting gids, and this appears to be
> the case, then let's go for this.

I see one problem with gid style - as gid is a per pid_namespace thing,
it should be configurable per pid_namespace.

But on the other hand, a potential bug might lead to a privilege
escalation (not a in-namespace root, but e.g. arbitrary write into any
physical address) due to the nature of the syscall.  So, in-namespace
root shouldn't be able to configure who is able to do vm86(2), otherwise
it is able to gain full root.

I'm confused :\

-- 
Vasiliy
