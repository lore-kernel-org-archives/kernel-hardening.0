Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jLC-drraZ3D5bj3_rO4LEFiUhutHHw7U8AfDyAEHg+xtg@mail.gmail.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-9-git-send-email-elena.reshetova@intel.com>
 <20170105022535.GA20972@linaro.org> <2236FBA76BA1254E88B949DDB74E612B41C380E4@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKYN8WS-mkAfBNOyJ2+Zpy=0ErxS8Ow6K0hAWgkyb9Bpw@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3A6D8@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKDYE7AHrXchNDLmvNMbvGytZDks6W1=i6+fyFX9ZGoNA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3BD08@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jJe0F_z5unvTg7y1myka+AP7Qn5mShEw9DS2M+c=NqpBA@mail.gmail.com> <CAGXu5jLC-drraZ3D5bj3_rO4LEFiUhutHHw7U8AfDyAEHg+xtg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 11 Jan 2017 18:55:02 -0800
Message-ID: <CAGXu5jLMjYa8vWVrx5njYrMqa7QR6ibdRLNM62EmNahZB7GWeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH 08/19] kernel, mm: convert from
 atomic_t to refcount_t
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 11, 2017 at 2:55 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jan 11, 2017 at 1:42 PM, Kees Cook <keescook@chromium.org> wrote:
>> I can see if it'll cherry-pick cleanly, I assume it will. :)
>
> It cherry-picked cleanly. However, I made several changes:
>
> - I adjusted Peter's author email (it had extra []s around).
> - I fixed all of the commit subjects (Peter's were missing).
> - I added back "kref: Add KREF_INIT()" since it seems to have been
> lost and mixed into other patches that would break bisection
>
> It's here now, please work from this version:
>
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kspp/hardened-atomic
>
> 0-day should see it soon. :)

FWIW, I was able to reproduce a bunch of the 0-day errors with an
allyesconfig build.

-Kees

-- 
Kees Cook
Nexus Security
