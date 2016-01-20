Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 20 Jan 2016 08:12:08 +0100
From: Marcus Meissner <meissner@suse.de>
Message-ID: <20160120071208.GA14085@suse.de>
References: <20160119112812.GA10818@mwanda>
 <569E6ADC.2090306@hurleysoftware.com>
 <CA+5PVA7C=LDkVNR3v0qxKu8OasJ49fG51aRGwDwA2QOAFGNXhw@mail.gmail.com>
 <20160119175154.GA7485@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160119175154.GA7485@kroah.com>
Subject: Re: [kernel-hardening] Re: 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Peter Hurley <peter@hurleysoftware.com>, Dan Carpenter <dan.carpenter@oracle.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 09:51:54AM -0800, Greg KH wrote:
> On Tue, Jan 19, 2016 at 12:00:57PM -0500, Josh Boyer wrote:
> > On Tue, Jan 19, 2016 at 11:57 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> > > On 01/19/2016 03:28 AM, Dan Carpenter wrote:
> > >> I like to look back over old CVEs to see how we could do better.  Here
> > >> is the list from 2015.  I got most of this information from the Ubuntu
> > >> CVE tracker.  Thanks Ubuntu!.  If it doesn't have a hash that means it
> > >> might not be fixed yet.
> > >
> > > [...]
> > >
> > >> CVE-2015-4170 cf872776fc84: tty: hang in tty
> > >
> > > Makes no sense that this was assigned a CVE.
> > > I fixed this _2 yrs before_ it was reported and the patch was CC'd stable.
> > 
> > I'm guessing the CVE was assigned because there are distributions that
> > ship based on kernels earlier than 3.13.  Those distributors need to
> > verify if they have the fix, etc.
> 
> Yes, that's what happened here, Red Hat asked for it from what I
> remember.  I complained loudly on the oss-security list about it, but oh
> well...

The question for CVE assignment is more if this bug existed in shipped kernel releases, not
when it was fixed in relation to assignment.

Ciao, Marcus
