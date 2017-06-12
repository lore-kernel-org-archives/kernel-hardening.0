From: Krzysztof Opasiak <k.opasiak@samsung.com>
Message-id: <75f33a0f-4643-fe17-fc35-b60b48efd499@samsung.com>
Date: Mon, 12 Jun 2017 19:35:06 +0200
MIME-version: 1.0
In-reply-to: <1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com>
Content-type: text/plain; charset="windows-1252"; format="flowed"
Content-transfer-encoding: 7bit
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
	<CGME20170612170045epcas2p2889350eed8fb2caaa592ef8e6e2c12bf@epcas2p2.samsung.com>
	<1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] Re: [PATCH 03/11] Creation of "usb_device_auth" LSM hook
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On 06/12/2017 06:56 PM, Salvatore Mesoraca wrote:
> Creation of a new LSM hook that can be used to authorize or deauthorize
> new USB devices via the usb authorization interface.
> The same hook can also prevent the authorization of a USB device via
> "/sys/bus/usb/devices/DEVICE/authorized".
> Using this hook an LSM could provide an higher level of granularity
> than the current authorization interface.
>

Could you please explain me why we need LSM for this?

There are tools like usbguard[1] and as far as I can tell it looks like 
they can do everything for you...
Without kernel modification...
without matching and storing rules inside kernel..
just pure userspace which uses device/interface authorization

Footnote:
1 - https://dkopecek.github.io/usbguard/

Best regards,
-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
