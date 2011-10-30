Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <201106161340.16117.arnd@arndb.de>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
	<201106161050.27716.arnd@arndb.de>
	<20110616085842.GB3215@albatros>
	<201106161340.16117.arnd@arndb.de>
Date: Sun, 30 Oct 2011 18:09:40 +0100
Message-ID: <CAFLxGvxSBV9yF2AjXR5A3e-yLDXqMpS+GUFip1JhtzUc5Q0org@mail.gmail.com>
From: richard -rw- weinberger <richard.weinberger@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount options
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2011 at 12:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 16 June 2011, Vasiliy Kulikov wrote:
>> > I have no opinion on whether it's a good idea to include the feature o=
r not.
>>
>> Why not? =A0Have you some specific complains where it can be perhaps too
>> strong/insufficient/non-configurable?
>
> No, not at all. I just haven't had the need for this myself, and I'm not
> enough of a security person to judge whether the vulnerability addressed
> by the patch is a relevant one. E.g. if all the sensitive information
> you are hiding in procfs is still available through netlink, your patch
> is pointless. Similarly if there is no recorded case of an attack that
> relies on any of the information in procfs.
>

Is this interface somewhere documented?
IOW how is it possible to get all processes via netlink?

--=20
Thanks,
//richard
