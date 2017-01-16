Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 16 Jan 2017 16:25:55 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Message-ID: <20170116212555.GA5201@fieldses.org>
References: <20170116164944.GA28984@kroah.com>
 <20170116165031.GB29693@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170116165031.GB29693@kroah.com>
Subject: [kernel-hardening] Re: [PATCH 2/3] Make static usermode helper binaries constant
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Sailer <t.sailer@alumni.ethz.ch>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, Jeff Layton <jlayton@poochiereds.net>, David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 16, 2017 at 05:50:31PM +0100, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> There are a number of usermode helper binaries that are "hard coded" in
> the kernel today, so mark them as "const" to make it harder for someone
> to change where the variables point to.
> 
...
> --- a/drivers/pnp/pnpbios/core.c
> +++ b/drivers/pnp/pnpbios/core.c
> @@ -98,6 +98,7 @@ static struct completion unload_sem;
>   */
>  static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
>  {
> +	static char const sbin_pnpbios[] = "/sbin/pnpbios";
>  	char *argv[3], **envp, *buf, *scratch;
>  	int i = 0, value;
>  
> @@ -112,7 +113,7 @@ static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
>  	 * integrated into the driver core and use the usual infrastructure
>  	 * like sysfs and uevents
>  	 */
> -	argv[0] = "/sbin/pnpbios";
> +	argv[0] = (char *)sbin_pnpbios;

So here and elsewhere, can attackers write to argv[0] instead of to the
memory where the string lives?

Apologies if I'm rehashing earlier discussion, I did a quick search of
archives but could easily have missed something.

--b.
