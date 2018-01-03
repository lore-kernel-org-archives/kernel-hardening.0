MIME-Version: 1.0
In-Reply-To: <CAErMHp_zm2UbUyd=E3gKOLUbjq+t+gnphUsxbUYjCMqOQN86qA@mail.gmail.com>
References: <20171221075036.GA32158@pjb1027-Latitude-E5410>
 <CAKv+Gu_wcy=VG8CK_qScY5Pw+=1k4NTHPsbP=ALEExs4anoFTQ@mail.gmail.com>
 <CAKv+Gu9j7YmF5UUjs0ZAVbws1jEuuoUbCwo68QgD7eAv7Uh16g@mail.gmail.com> <CAErMHp_zm2UbUyd=E3gKOLUbjq+t+gnphUsxbUYjCMqOQN86qA@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 3 Jan 2018 13:57:55 +0000
Message-ID: <CAKv+Gu-Fx0w2FiHmJExKM=sBA3MwOr5KOKa6jQ7cB0aBBgPDQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH] arm: kernel: implement fast refcount checking
To: Jinbum Park <jinb.park7@gmail.com>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, boqun.feng@gmail.com, Ingo Molnar <mingo@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, mickael.guene@st.com, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 3 January 2018 at 13:36, Jinbum Park <jinb.park7@gmail.com> wrote:
>>> This is a nice result. However, without any insight into the presence
>>> of actual refcount hot spots, it is not obvious that we need this
>>> patch. This is the reason we ended up enabling CONFIG_REFCOUNT_FULL
>>> for arm64. I will let others comment on whether we want this patch in
>>> the first place,
>
> Dear Ard, Dave,
>
> I wanna hear some comment on above point.
> Is CONFIG_REFCOUNT_FULL much better for arm?
> If it is, I don't need to prepare v2 patch. (then, just needed to add
> "select REFCOUNT_FULL")
>

Well, we should probably turn that around. Please use REFCOUNT_FULL,
until you run into a use case where the slowdown is noticeable. If
nobody ever notices, we don't need to fix anything.
