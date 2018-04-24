MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180424195845.GB23575@mail.hallyn.com>
References: <20180424010321.14739-1-tycho@tycho.ws> <20180424045015.GA4281@sol.localdomain>
 <20180424143539.GB3125@cisco> <201804242346.FHI69745.SQMHFVOOFLFOJt@I-love.SAKURA.ne.jp>
 <20180424145104.GC3125@cisco> <20180424195845.GB23575@mail.hallyn.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 24 Apr 2018 13:04:58 -0700
Message-ID: <CAGXu5j+SXCJpm9xnX1UaY0Qz2+E0qNETc+s8kwrH6hE9LLjgpw@mail.gmail.com>
Subject: Re: [PATCH 1/3] big key: get rid of stack array allocation
Content-Type: text/plain; charset="UTF-8"
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Tycho Andersen <tycho@tycho.ws>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, James Morris <jmorris@namei.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 24, 2018 at 12:58 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Tycho Andersen (tycho@tycho.ws):
>> On Tue, Apr 24, 2018 at 11:46:38PM +0900, Tetsuo Handa wrote:
>> > Tycho Andersen wrote:
>> > > > > +     if (unlikely(crypto_aead_ivsize(big_key_aead) != GCM_AES_IV_SIZE)) {
>> > > > > +             WARN(1, "big key algorithm changed?");
>> >
>> > Please avoid using WARN() WARN_ON() etc.
>> > syzbot would catch it and panic() due to panic_on_warn == 1.
>>
>> But it is really a programming bug in this case (and it seems better
>> than BUG()...). Isn't this exactly the sort of case we want to catch?
>>
>> Tycho
>
> Right - is there a url to some discussion about this?  Because not
> using WARN when WARN should be used, because it troubles a bot, seems
> the wrong solution.  If this *is* what's been agreed upon, then
> what is the new recommended thing to do here?

BUG() is basically supposed to never be used, as decreed by Linus.
WARN() here is entirely correct: if we encounter a case where
crypto_aead_ivsize(big_key_aead) != GCM_AES_IV_SIZE is not true, we
run the risk of stack memory corruption. If this is an EXPECTED
failure case, then okay, drop the WARN() but we have to keep the
-EINVAL.

-Kees

-- 
Kees Cook
Pixel Security
