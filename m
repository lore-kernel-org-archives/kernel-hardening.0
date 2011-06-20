Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Jun 2011 18:11:37 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110620141137.GA31044@openwall.com>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org> <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org> <20110620103917.GA5230@albatros> <BANLkTimb==tuDKQ2jyYS+Py0FfNxKVc+Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimb==tuDKQ2jyYS+Py0FfNxKVc+Pg@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy -

On Mon, Jun 20, 2011 at 04:58:10PM +0300, Alexey Dobriyan wrote:
> gid= is bad choice because
> a) e. g. VFAT uses uid=/gid= mount options to make all inodes to have
> certain uid/gid
> b) uid=/gid=, IIRC, will be added as generic VFS mount options (like ro)
>    with semantics described in a)
> 
> so having different semantics for /proc won't be good.

I lost track of your proposals/patches.  Aren't you currently proposing
that gid= would make all inodes have the specified gid?  If not, why
not?  Such semantics sound fine to me.  That's what gid= does on procfs
on Linux 2.4.x-ow.

Please explain.

Thanks,

Alexander
