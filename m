MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEiveUdFL53XyQpacmN6f8F28M0bLQDcetpRXJjrJ10vDmQi8Q@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-2-git-send-email-tixxdz@gmail.com> <1492654942.31767.21.camel@decadent.org.uk>
 <CAEiveUdS=GbyxDVeNFrjTmhvQB-a6UgrJXcGY=BYJLu+3z0x_Q@mail.gmail.com>
 <1492700543.31767.23.camel@decadent.org.uk> <CAEiveUdFL53XyQpacmN6f8F28M0bLQDcetpRXJjrJ10vDmQi8Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 20 Apr 2017 14:28:59 -0700
Message-ID: <CAGXu5j+L9=tGH2xCKJ53NDYRM8PVVYyC2R8w7uahBO88cftZNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v3 1/2] modules:capabilities:
 automatic module loading restriction
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, Zendyani <zendyani@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 20, 2017 at 1:39 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
> On Thu, Apr 20, 2017 at 5:02 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> On Thu, 2017-04-20 at 14:44 +0200, Djalal Harouni wrote:
>>> > On Thu, Apr 20, 2017 at 4:22 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>>> > On Thu, 2017-04-20 at 00:20 +0200, Djalal Harouni wrote:
>>> > [...]
> [...]
>>> modules_disabled is too restrictive and once set it can't be changed,
>>> maybe that's why not all users use it.
>>>
>>> With modules_disabled=0 and modules_autoload=2
>> [...]
>>
>> Hmm, OK.  How about naming this modules_autoload_mode, then, so that
>> it's obviously not a boolean?
>
> Yes that's fine by me, kees already suggested to rename it to
> "modules_autoload" I can change it to that if it's the best
> suggestion!

That's fine by me.

-Kees

-- 
Kees Cook
Pixel Security
