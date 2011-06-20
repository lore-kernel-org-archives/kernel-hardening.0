Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Jun 2011 18:47:39 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110620144739.GA31510@openwall.com>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org> <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org> <20110620103917.GA5230@albatros> <BANLkTimb==tuDKQ2jyYS+Py0FfNxKVc+Pg@mail.gmail.com> <20110620141137.GA31044@openwall.com> <20110620141951.GA11607@albatros> <20110620142555.GA31234@openwall.com> <20110620143550.GA11835@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620143550.GA11835@albatros>
Subject: Re: [kernel-hardening] [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Jun 20, 2011 at 06:35:50PM +0400, Vasiliy Kulikov wrote:
> I didn't post a patch with taskstats and sysctl variables to LKML yet
> (only the changes in ptrace/capabilities code).

I don't understand the rationale behind the latter.  I can try to guess,
but I'd prefer to see a simple explanation from you.  (Maybe I missed
one.)  It sounds like you're going to spend considerable time on those
changes, but it is not clear to me whether they're needed or not.

So please explain (maybe in a more proper thread than this one).

Unfortunately, I won't have time to participate in a discussion on this
today (nor in the following few days), but I'd like to be informed
anyway and maybe others will comment.

Thanks,

Alexander
