Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 11:27:02 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Message-ID: <20170119162702.GE17183@fieldses.org>
References: <20170116164944.GA28984@kroah.com>
 <20170116165031.GB29693@kroah.com>
 <20170116212555.GA5201@fieldses.org>
 <20170117071347.GA7296@kroah.com>
 <20170117151911.GA13787@fieldses.org>
 <20170117152919.GA4640@kroah.com>
 <20170119120321.GA3396@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170119120321.GA3396@kroah.com>
Subject: Re: [kernel-hardening] Re: [PATCH 2/3] Make static usermode helper
 binaries constant
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Sailer <t.sailer@alumni.ethz.ch>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, Jeff Layton <jlayton@poochiereds.net>, David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 19, 2017 at 01:03:21PM +0100, Greg KH wrote:
> On Tue, Jan 17, 2017 at 04:29:19PM +0100, Greg KH wrote:
> > On Tue, Jan 17, 2017 at 10:19:11AM -0500, J. Bruce Fields wrote:
> > > On Tue, Jan 17, 2017 at 08:13:47AM +0100, Greg KH wrote:
> > > > On Mon, Jan 16, 2017 at 04:25:55PM -0500, J. Bruce Fields wrote:
> > > > > On Mon, Jan 16, 2017 at 05:50:31PM +0100, Greg KH wrote:
> > > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > 
> > > > > > There are a number of usermode helper binaries that are "hard coded" in
> > > > > > the kernel today, so mark them as "const" to make it harder for someone
> > > > > > to change where the variables point to.
> > > > > > 
> > > > > ...
> > > > > > --- a/drivers/pnp/pnpbios/core.c
> > > > > > +++ b/drivers/pnp/pnpbios/core.c
> > > > > > @@ -98,6 +98,7 @@ static struct completion unload_sem;
> > > > > >   */
> > > > > >  static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
> > > > > >  {
> > > > > > +	static char const sbin_pnpbios[] = "/sbin/pnpbios";
> > > > > >  	char *argv[3], **envp, *buf, *scratch;
> > > > > >  	int i = 0, value;
> > > > > >  
> > > > > > @@ -112,7 +113,7 @@ static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
> > > > > >  	 * integrated into the driver core and use the usual infrastructure
> > > > > >  	 * like sysfs and uevents
> > > > > >  	 */
> > > > > > -	argv[0] = "/sbin/pnpbios";
> > > > > > +	argv[0] = (char *)sbin_pnpbios;
> > > > > 
> > > > > So here and elsewhere, can attackers write to argv[0] instead of to the
> > > > > memory where the string lives?
> > > > 
> > > > Yes, they could, it would be a very "tight" race to do that (have to
> > > > write after the assignment and before the call_usermodehelper_exec()
> > > > runs).  However, the kernel does not run argv[0], it just passes it to
> > > > the binary you specify in path, so for this example, the correct program
> > > > would still be run by the kernel.
> > > 
> > > In this case it's argv[0] that will be passed to call_usermodehelper as
> > > path, but.... OK, this argv array and the various function call
> > > arguments are all just data on the stack, so I guess it's all about
> > > equivalent.
> > 
> > Kind of, nice catch, I'll change the call to usermodehelper to use
> > sbin_pnpbios here, as that's the right thing to do.
> 
> Oops, no, the patch was doing the right thing here, you missed the next
> chunk of the patch:

Oh, got it, thanks.

--b.

> 
> 
> @@ -139,7 +140,7 @@ static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
>                            info->location_id, info->serial, info->capabilities);
>         envp[i] = NULL;
> 
> -       value = call_usermodehelper(argv [0], argv, envp, UMH_WAIT_EXEC);
> +       value = call_usermodehelper(sbin_pnpbios, argv, envp, UMH_WAIT_EXEC);
>         kfree(buf);
>         kfree(envp);
>         return 0;
> 
> 
> So it's ok.
> 
> thanks,
> 
> greg k-h
