From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [RESEND] rsi: Remove stack VLA usage
References: <1520819022-15238-1-git-send-email-me@tobin.cc>
	<20180312094606.8192B6081A@smtp.codeaurora.org>
	<20180313201757.GK8631@eros>
	<CAHp75VeM1zNyNtHvsn0=rg_xibcitVHREY73cAk=KCSK3Ti3vw@mail.gmail.com>
	<20180314021151.GA11666@eros>
Date: Wed, 14 Mar 2018 11:11:12 +0200
In-Reply-To: <20180314021151.GA11666@eros> (Tobin C. Harding's message of
	"Wed, 14 Mar 2018 13:11:51 +1100")
Message-ID: <87k1uf6mz3.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, kernel-hardening@lists.openwall.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

"Tobin C. Harding" <me@tobin.cc> writes:

> On Tue, Mar 13, 2018 at 11:00:47PM +0200, Andy Shevchenko wrote:
>> On Tue, Mar 13, 2018 at 10:17 PM, tcharding <me@tobin.cc> wrote:
>> > On Mon, Mar 12, 2018 at 09:46:06AM +0000, Kalle Valo wrote:
>> >> tcharding <me@tobin.cc> wrote:
>>=20
>> I'm pretty much sure it depends on the original email headers, like
>> above ^^^ =E2=80=94 no name.
>> Perhaps git config on your side should be done.
>
> Thanks for the suggestion Andy but the 'tcharding' as the name was
> munged by either Kalle or patchwork.  I'm guessing patchwork.

You guessed corretly, patchwork is here to blame. I sent my "please
rebase" mail earlier in this thread using my custom patchwork client
script (pwcli) which takes the name and address from patchwork.

Andy, this is definitely a bug in patchwork and I have seen this issue
multiple times already. I have understood that it has been fixed in a
recent version but patchwork.kernel.org is still running an old version.
In the original mail Tobin did have the correct From header which can be
checked from the headers in patch page[1]:

From: "Tobin C. Harding" <me@tobin.cc>

[1] https://patchwork.kernel.org/patch/10274983/

--=20
Kalle Valo
