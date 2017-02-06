MIME-Version: 1.0
In-Reply-To: <201702061949.HGE43791.FFFtJVSHQOOLOM@I-love.SAKURA.ne.jp>
References: <1486055094-4532-1-git-send-email-djalal@gmail.com>
 <1486055094-4532-2-git-send-email-djalal@gmail.com> <201702061949.HGE43791.FFFtJVSHQOOLOM@I-love.SAKURA.ne.jp>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 6 Feb 2017 14:10:26 +0100
Message-ID: <CAEiveUf1RZmyWQRYzK4WvJfAgedTX+1OcpVG_5yHELHFo0Dd7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC/PATCH 1/3] security: add the security_task_copy() hook
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>, Dongsu Park <dongsu@endocode.com>, Andy Lutomirski <luto@kernel.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Daniel Mack <daniel@zonque.org>, Jann Horn <jann@thejh.net>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 6, 2017 at 11:49 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Djalal Harouni wrote:
>> To achieve the above we add the security_task_copy() hook that allows us
>> to clone the Timgad context of parent into child task_struct.
>>
>> The security hook can also be used by new LSMs after the child task has
>> done some initialization, this way they won't clash with the major LSMs.
>> The situation is not really well, this hook allows us to introduce a
>> stackable LSM that can be easily used with all other LSMs.
>
> We are already planning to revive security_task_alloc() hook (probably in Linux 4.12)
> ( news://news.gmane.org:119/201701101958.JAD43709.OtJSOQFVFOLHMF@I-love.SAKURA.ne.jp ).
> Is security_task_alloc() called too early for your case?
>
> (Well, we want to configure http archive like marc.info ?)

I found this marc.info
http://marc.info/?l=linux-security-module&m=129584883703846

Oups from 2011! your email pretty sum up all the approach that I took
:-) , and yes it was not that obvious... so I did it that way where
the data is kept in an external table. Also yes beside TOMOYO I also
need that hook for the various reasons that are listed in that thread.

Thanks!

-- 
tixxdz
