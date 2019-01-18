From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] gcc-plugins: fixes for arm_ssp_per_task_plugin
Date: Fri, 18 Jan 2019 11:58:05 +0100
Message-Id: <20190118105807.26425-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: keescook@chromium.org
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

A couple of fixes to permit newer versions of GCC to use the stack
protector plugin for ARM.

Ard Biesheuvel (2):
  gcc-plugins: arm_ssp_per_task_plugin: sign extend the SP mask
  gcc-plugins: arm_ssp_per_task_plugin: fix for GCC 9+

 scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 23 ++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

-- 
2.20.1
