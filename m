Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 20 Dec 2016 11:31:57 +0100 (CET)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <alpine.LSU.2.20.1612201117220.19203@cbobk.fhfr.pm>
Message-ID: <alpine.LSU.2.20.1612201129320.19203@cbobk.fhfr.pm>
References: <20161214185000.GA3930@kroah.com> <87k2b0wus6.fsf@notabene.neil.brown.name> <20161216124913.GB31485@kroah.com> <alpine.LRH.2.00.1612191428060.15543@gjva.wvxbf.pm> <20161220092734.GA12200@kroah.com>
 <alpine.LSU.2.20.1612201117220.19203@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC 0/4] make call_usermodehelper a bit more "safe"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: NeilBrown <neilb@suse.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 20 Dec 2016, Jiri Kosina wrote:

> I stay totally unconvinced that such kind of countermeasure brings any 
> value whatsoever. Could you please bring up a particular usecase, where 
> you have complete control over kernel memory, and still the only 
> possible exploit factor is redirecting usermodhelper? It feels like 
> rather random shot into darkness.

If we want to make usermod helper really secure, perhaps the best way to 
go would be to completely nuke it and handle everyhting in udev; that'd be 
quite some work though, especially so that we don't break all the corner 
cases of module autoloading (request_module() and such).

Thanks,

-- 
Jiri Kosina
SUSE Labs
