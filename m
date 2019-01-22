Date: Mon, 21 Jan 2019 19:01:42 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] tty: ldisc: add sysctl to prevent autoloading of ldiscs
Message-ID: <20190122000142.GB19379@mit.edu>
References: <20190121162642.GA2944@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190121162642.GA2944@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 21, 2019 at 05:26:42PM +0100, Greg Kroah-Hartman wrote:
> By default, the kernel will automatically load the module of any line
> dicipline that is asked for.  As this sometimes isn't the safest thing
> to do, provide a sysctl to disable this feature.
> 
> By default, we set this to 'y' as that is the historical way that Linux
> has worked, and we do not want to break working systems.  But in the
> future, perhaps this can default to 'n' to prevent this functionality.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
