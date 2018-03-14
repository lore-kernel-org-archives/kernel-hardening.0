Date: Wed, 14 Mar 2018 14:43:03 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [RESEND] rsi: Remove stack VLA usage
Message-ID: <20180314034303.GB11666@eros>
References: <1520819022-15238-1-git-send-email-me@tobin.cc>
 <20180312094606.8192B6081A@smtp.codeaurora.org>
 <20180313201757.GK8631@eros>
 <CAHp75VeM1zNyNtHvsn0=rg_xibcitVHREY73cAk=KCSK3Ti3vw@mail.gmail.com>
 <20180314021151.GA11666@eros>
 <CAGXu5jJsDsegY+EZFq1Hip+sRNLR5SS+-Euf1rm22okAq7REJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jJsDsegY+EZFq1Hip+sRNLR5SS+-Euf1rm22okAq7REJw@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Kalle Valo <kvalo@codeaurora.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Added Konstantin in case he is in charge of administering patchwork.kernel.org?

On Tue, Mar 13, 2018 at 07:53:34PM -0700, Kees Cook wrote:
> On Tue, Mar 13, 2018 at 7:11 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > On Tue, Mar 13, 2018 at 11:00:47PM +0200, Andy Shevchenko wrote:
> >> On Tue, Mar 13, 2018 at 10:17 PM, tcharding <me@tobin.cc> wrote:
> >> > On Mon, Mar 12, 2018 at 09:46:06AM +0000, Kalle Valo wrote:
> >> >> tcharding <me@tobin.cc> wrote:
> >>
> >> I'm pretty much sure it depends on the original email headers, like
> >> above ^^^ — no name.
> >> Perhaps git config on your side should be done.
> >
> > Thanks for the suggestion Andy but the 'tcharding' as the name was
> > munged by either Kalle or patchwork.  I'm guessing patchwork.
> 
> Something you're sending from is using "tcharding" (see the email Andy
> quotes). I see the headers as:
> 
> Date: Wed, 14 Mar 2018 07:17:57 +1100
> From: tcharding <me@tobin.cc>
> ...
> Message-ID: <20180313201757.GK8631@eros>
> X-Mailer: Mutt 1.5.24 (2015-08-30)
> User-Agent: Mutt/1.5.24 (2015-08-30)
> 
> Your most recently email shows "Tobin C. Harding" though, and also
> sent with Mutt...
>
> Do you have multiple Mutt configurations? Is something lacking a
> "From" header insertion and your MTA is filling it in for you from
> your username?

Thanks for taking the time to respond Kees (and Tycho).  I have mutt
configured to reply from whichever email address I receive from so if
patchwork sent an email to 'tcharding <me@tobin.cc>' (which is the
details it has) and I hit reply it would have come from 'tcharding',
hence Andy's reply.  I wouldn't bet my life on it but I'm kinda
confident that I cannot initiate an email from 'tcharding' with my
current set up.

Super bad form to blame someone (or something else) but I think this is
a problem with how my patchwork account is configured.  Either way, that
is still my fault I should have added my real name to patchwork when I
signed up (not just username 'tcharding').

Is patchwork.kernel.org administered by Konstantin Ryabitsev? Added
Konstantin to CC's.

thanks,
Tobin.
