Subject: Re: [PATCH v2 1/3] security: Create "kernel hardening" config area
References: <20190411180117.27704-1-keescook@chromium.org>
 <20190411180117.27704-2-keescook@chromium.org>
 <947dbe9a-3444-6fe4-9f79-f8f210da8960@linux.com>
 <CAGXu5jJTM=pdAjsC63Z6T=HaztTqSqUQQ8=GN=tqv2n6CKc3nw@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <450e21b0-606a-f19a-a4fe-f7508d6a215c@linux.com>
Date: Tue, 16 Apr 2019 16:55:30 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJTM=pdAjsC63Z6T=HaztTqSqUQQ8=GN=tqv2n6CKc3nw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Alexander Potapenko <glider@google.com>, James Morris <jmorris@namei.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 16.04.2019 7:02, Kees Cook wrote:
> On Mon, Apr 15, 2019 at 11:44 AM Alexander Popov <alex.popov@linux.com> wrote:
>>
>> What do you think about some separator between memory initialization options and
>> CONFIG_CRYPTO?
> 
> This was true before too

Hm, yes, it's a generic behavior - there is no any separator at 'endmenu' and
config options stick together.

I've created a patch to fix that. What do you think about it?
I can send it to LKML separately.


>From 50bf59d30fafcdebb3393fb742e1bd51e7d2f2da Mon Sep 17 00:00:00 2001
From: Alexander Popov <alex.popov@linux.com>
Date: Tue, 16 Apr 2019 16:09:40 +0300
Subject: [PATCH 1/1] kconfig: Terminate menu blocks with a newline in the
 generated config

Currently menu blocks start with a pretty header but end with nothing in
the generated config. So next config options stick together with the
options from the menu block.

Let's terminate menu blocks with a newline in the generated config.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 scripts/kconfig/confdata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 08ba146..1459153 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -888,6 +888,8 @@ int conf_write(const char *name)
 		if (menu->next)
 			menu = menu->next;
 		else while ((menu = menu->parent)) {
+			if (!menu->sym && menu_is_visible(menu))
+				fprintf(out, "\n");
 			if (menu->next) {
 				menu = menu->next;
 				break;
-- 
2.7.4
