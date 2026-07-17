-- CreateTable
CREATE TABLE "Bean" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL DEFAULT 1,
    "name" TEXT NOT NULL,
    "origin" TEXT NOT NULL,
    "roastery" TEXT NOT NULL,
    "process" TEXT NOT NULL,
    "roastLevel" TEXT NOT NULL,
    "notes" TEXT,
    "favorite" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Bean_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bag" (
    "id" SERIAL NOT NULL,
    "beanId" INTEGER NOT NULL,
    "roastDate" TIMESTAMP(3) NOT NULL,
    "amountGrams" INTEGER NOT NULL,
    "purchaseDate" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Bag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Brew" (
    "id" SERIAL NOT NULL,
    "beanId" INTEGER NOT NULL,
    "method" TEXT NOT NULL,
    "grinder" TEXT,
    "grindSetting" TEXT,
    "coffeeDose" DOUBLE PRECISION NOT NULL,
    "waterAmount" DOUBLE PRECISION NOT NULL,
    "waterTemp" INTEGER,
    "brewTimeSec" INTEGER,
    "rating" INTEGER NOT NULL,
    "acidity" INTEGER NOT NULL,
    "sweetness" INTEGER NOT NULL,
    "bitterness" INTEGER NOT NULL,
    "body" INTEGER NOT NULL,
    "aftertaste" INTEGER NOT NULL,
    "notes" TEXT,
    "brewedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Brew_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Bean_userId_idx" ON "Bean"("userId");

-- CreateIndex
CREATE INDEX "Bag_beanId_idx" ON "Bag"("beanId");

-- CreateIndex
CREATE INDEX "Brew_beanId_idx" ON "Brew"("beanId");

-- AddForeignKey
ALTER TABLE "Bag" ADD CONSTRAINT "Bag_beanId_fkey" FOREIGN KEY ("beanId") REFERENCES "Bean"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Brew" ADD CONSTRAINT "Brew_beanId_fkey" FOREIGN KEY ("beanId") REFERENCES "Bean"("id") ON DELETE CASCADE ON UPDATE CASCADE;
