Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <99FC4B6EFCEFD44486C35F4C281DC6731F1DFFDA@ORSMSX107.amr.corp.intel.com>
References: <99FC4B6EFCEFD44486C35F4C281DC6731F1DFFDA@ORSMSX107.amr.corp.intel.com>
Date: Fri, 11 Dec 2015 10:47:49 -0800
Message-ID: <CAGXu5j+Q3pKN7G9OgCop-DPbq6vjTOL-PoVHTP0tSwxdyjGiJw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Project convention on configuration options
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 11, 2015 at 9:57 AM, Schaufler, Casey
<casey.schaufler@intel.com> wrote:
> I=E2=80=99m starting to look at PAX_USERCOPY and immediately hit
> the question of what to do about configuration option name.
> I assume that retaining PAX_USERCOPY is not the right thing
> to do, but what should be used instead? HARD_USERCOPY?

I think there will be plenty of bike-shedding, so pick whatever you
like for now. :)

There is already the (disabled due to gcc bugs)
DEBUG_STRICT_USER_COPY_CHECKS (which should lose the "DEBUG" name
too). IIRC, it works by tracking memory regions? Maybe TRACK_USERCOPY?
I'm sure it'll get renamed, so no big deal. In fact, you could just
leave it as PAX_USERCOPY too for the initial extraction.

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
