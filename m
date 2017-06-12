Date: Mon, 12 Jun 2017 21:38:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170612193826.GA4235@kroah.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] Re: [PATCH 03/11] Creation of "usb_device_auth" LSM hook
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-usb@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 12, 2017 at 06:56:52PM +0200, Salvatore Mesoraca wrote:
> Creation of a new LSM hook that can be used to authorize or deauthorize
> new USB devices via the usb authorization interface.
> The same hook can also prevent the authorization of a USB device via
> "/sys/bus/usb/devices/DEVICE/authorized".
> Using this hook an LSM could provide an higher level of granularity
> than the current authorization interface.
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> Cc: linux-usb@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

No, like Krzysztof said, you can already do this today, just fine, from
userspace.  I think that support has been there for over a decade now,
why are you not taking advantage of this already?

No need to add extra stuff to the kernel at all to do this, sorry you
implemented all of this for no reason :(

greg k-h
