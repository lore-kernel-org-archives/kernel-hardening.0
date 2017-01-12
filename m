Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 12 Jan 2017 08:37:46 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170112073746.GA23596@kroah.com>
References: <CAPDLWs8g5CRTDwDuuLuuGh8K30Py_kGkjVfuT++Q09rT6XaQ=A@mail.gmail.com>
 <CAGXu5j+oOJoJ3JFzEpv4jNeCLu95-QVfYQ8mP-M-waqyvoDDRg@mail.gmail.com>
 <CAPDLWs_DwbB7ZJJ55W8Hz6vnNGDPVvbSw__+1qh42jjNrcCQYA@mail.gmail.com>
 <CAGXu5jJqo99Vheuod5DPobzBpGMz7zw_CHvG4iNuOU87x-REFA@mail.gmail.com>
 <CAPDLWs8dMyk3CGpt49w0Nyd59ZDDOSMz87vkm5k7NkObAZNzog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDLWs8dMyk3CGpt49w0Nyd59ZDDOSMz87vkm5k7NkObAZNzog@mail.gmail.com>
Subject: Re: [kernel-hardening] New to KSPP, would like to contribute
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 12, 2017 at 09:01:05AM +0530, Kaiwan N Billimoria wrote:
> Okay, thanks, I see it better now :)
> 
> Forgive my silly qs: 
> so as I understand it, the objective is to start merging in some of the grsec
> code into mainline, yes? So, which kernel do we work on? the latest rc or do I
> work on the one where the above patch applies (i.e. 4.8.17)?

You can't go back in time and get stuff merged into an old patch, so
always work on the latest kernel tree.  Use linux-next so you don't end
up duplicating any effort that people have already done.

I suggest reading Documentation/development_process/ as a summary of how
all of this works.

thanks,

greg k-h
