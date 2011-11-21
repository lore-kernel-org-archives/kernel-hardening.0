Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20111119165903.GB2208@openwall.com>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<1319672956-17114-4-git-send-email-keescook@chromium.org>
	<20111119163058.GA3131@albatros>
	<20111119165903.GB2208@openwall.com>
Date: Mon, 21 Nov 2011 10:40:25 -0800
Message-ID: <CAGXu5j+C-LQT2z+J3jEJYmftt1jOnMujNjKqgy0JFwM7b_FPjQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 3/3] security: Yama: add ptrace relationship tracking interface
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 19, 2011 at 8:59 AM, Solar Designer <solar@openwall.com> wrote:
> On Sat, Nov 19, 2011 at 08:30:58PM +0400, Vasiliy Kulikov wrote:
>> On Wed, Oct 26, 2011 at 16:49 -0700, Kees Cook wrote:
>> > + =A0 if (mode =3D=3D PTRACE_MODE_ATTACH &&
>> > + =A0 =A0 =A0 ptrace_scope &&
>> > + =A0 =A0 =A0 !capable(CAP_SYS_PTRACE) &&
>> > + =A0 =A0 =A0 !task_is_descendant(current, child) &&
>> > + =A0 =A0 =A0 !ptracer_exception_found(current, child))
>> > + =A0 =A0 =A0 =A0 =A0 rc =3D -EPERM;
>>
>> capable() is better to put after all other tests
>
> Right, but...
>
>> as a failed capable()
>> might emit a false positive warning into logs or something.
>
> ...primarily for another reason: a successful capable() sets
> PF_SUPERPRIV, whereas the permission might have been granted without
> capable() as well. =A0The PF_SUPERPRIV flag is visible via BSD process
> accounting.

Fair point, I'll move it. I had to go look up an earlier thread since
this was ringing a bell, but in there I was talking about moving it to
the end of the tests too. :)

https://lkml.org/lkml/2010/6/30/5

-Kees

--=20
Kees Cook
ChromeOS Security
