Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <99FC4B6EFCEFD44486C35F4C281DC6731F1FBD13@ORSMSX107.amr.corp.intel.com>
References: <99FC4B6EFCEFD44486C35F4C281DC6731F1FBD13@ORSMSX107.amr.corp.intel.com>
Date: Tue, 19 Jan 2016 15:59:46 -0800
Message-ID: <CAGXu5jJpVgGqZKpFamF8urWxOd349QmUK4T3PV2nLG5agij0hw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: Still working on PAX_USERCOPY
To: "Schaufler, Casey" <casey.schaufler@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 14, 2016 at 5:43 PM, Schaufler, Casey
<casey.schaufler@intel.com> wrote:
> Just a brief status update on my work on PAX_USERCOPY. I=E2=80=99ve ditch=
ed my first
> two attempts at doing somewhat simple minded cut=E2=80=99n=E2=80=99patch =
and am going to
> have to take a more engineering (e.g. understanding what=E2=80=99s really=
 going on)
> approach. The good news is that I=E2=80=99ve made enough mistakes to thin=
k there
> aren=E2=80=99t that many left for a project this size.

Thanks for the report! Were you able to use or improve on the
lib/test_user_copy.c tests during your experiments? (Or maybe we just
need a separate lkdtm test?)

What kinds of dead-ends did you run into?

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
