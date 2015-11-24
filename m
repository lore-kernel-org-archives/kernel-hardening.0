Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 24 Nov 2015 13:20:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20151124212024.GB15374@kroah.com>
References: <CAEXv5_jnutg89zQLyLCupKf0AOZ=ubdgbJy7AgeeN=7yQicW0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXv5_jnutg89zQLyLCupKf0AOZ=ubdgbJy7AgeeN=7yQicW0A@mail.gmail.com>
Subject: Re: [kernel-hardening] status: PAX_REFCOUNT
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 24, 2015 at 02:37:41PM -0500, David Windsor wrote:
> I'm currently in the process of splitting PAX_REFCOUNT. 
> 
> It looks to touch a massive number of files.  Many of the modifications occur
> in drivers:
> 
> dave@strontium:~/src/linux-grsec-4.2$ grep -ril "atomic.*unchecked" | wc -l
> 402
> dave@strontium:~/src/linux-grsec-4.2$ grep -ril "atomic.*unchecked" drivers/ |
> wc -l
> 158

Odds are, we can take lots of these existing atomic usages and either
replace them with a kref, or remove them, as I can't imagine that we
need that many different atomic variables for things that are not just
debugging things.

thanks,

greg k-h
